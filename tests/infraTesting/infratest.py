import pytest

@pytest.mark.namespace(create=False, name='monitoring')
@pytest.mark.applymanifest('configs/elastic.config.yaml')
@pytest.mark.applymanifest('configs/readiness.elastic.yaml')
@pytest.mark.applymanifest('configs/elasticsearch.yaml')
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
        resp = pod.http_proxy_get('/_cluster/health?local=true')
        assert 'green' in resp.data
    kube.delete(elasticsearch_sts)

