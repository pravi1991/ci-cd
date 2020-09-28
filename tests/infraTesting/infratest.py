import pytest
@pytest.fixture
def kubeconfig():
    return '~/.kube/kubeconfig'
@pytest.mark.namespace(create=False, name='monitoring')
@pytest.mark.applymanifest('k8s-manifests/elastic.config.yaml')
@pytest.mark.applymanifest('k8s-manifests/readiness.elastic.cm.yaml')
@pytest.mark.applymanifest('k8s-manifests/elasticsearch.yaml')
def test_es(kube):
    kube.wait_for_registered()
    sts = kube.get_statefulsets('monitoring')
    service = kube.get_services('monitoring')
    elastic_service = service.get('elasticsearch-logging')
    elasticsearch_sts = sts.get('elasticsearch-master')
    assert elastic_service is not None
    assert elasticsearch_sts is not None
    pods = elasticsearch_sts.get_pods()
    # assert len(pods) == 3, 'pods should deploy with three replicas'
    assert len(pods) == 3, 'pods should deploy with three replicas'
    for pod in pods:
        resp = pod.http_proxy_get('/_cluster/health?local=true')
        assert 'green' in resp.data

@pytest.mark.namespace(create=False, name='monitoring')
@pytest.mark.applymanifest('k8s-manifests/kibana.config.yaml')
@pytest.mark.applymanifest('k8s-manifests/readiness.binana.cm.yaml')
@pytest.mark.applymanifest('k8s-manifests/kibana.yaml')
def test_es(kube):
    kube.wait_for_registered()
    sts = kube.get_statefulsets('monitoring')
    service = kube.get_services('monitoring')
    elastic_service = service.get('elasticsearch-logging')
    elasticsearch_sts = sts.get('elasticsearch-master')
    assert elastic_service is not None
    assert elasticsearch_sts is not None
    pods = elasticsearch_sts.get_pods()
    # assert len(pods) == 3, 'pods should deploy with three replicas'
    assert len(pods) == 1, 'pods should deploy with three replicas'
    for pod in pods:
        resp = pod.http_proxy_get('/app/kibana')
        assert 'not ready yet' not in resp.data
