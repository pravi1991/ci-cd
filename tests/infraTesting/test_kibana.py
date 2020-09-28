import pytest
@pytest.fixture
def kubeconfig():
    return '~/.kube/kubeconfig'
@pytest.mark.namespace(create=False, name='monitoring')
@pytest.mark.applymanifest('k8s-manifests/elastic.secret.password.yaml')
@pytest.mark.applymanifest('k8s-manifests/kibana.config.yaml')
@pytest.mark.applymanifest('k8s-manifests/readiness.kibana.cm.yaml')
@pytest.mark.applymanifest('k8s-manifests/kibana.yaml')
def test_kibana(kube):
    kube.wait_for_registered()
    deploy = kube.get_deployments('monitoring')
    service = kube.get_services('monitoring')
    kibana_service = service.get('kibana')
    kibana_deploy = deploy.get('kibana')
    assert kibana_service is not None
    assert kibana_deploy is not None
    pods = kibana_deploy.get_pods()
    assert len(pods) == 1, 'pods should deploy with one replicas'
    for pod in pods:
        resp = pod.http_proxy_get('/app/kibana')
        assert 'not ready yet' not in resp.data
