// +build kubeall kubernetes
// NOTE: See the notes in the other Kubernetes example tests for why this build tag is included.

package test

import (
	"fmt"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/k8s"
)

func TestKubernetesHelloWorldExample(t *testing.T) {
	t.Parallel()

	kubeResourcePath := "../examples/kubernetes-hello-world-example/hello-world-deployment.yml"

	options := k8s.NewKubectlOptions("", "", "default")

	defer k8s.KubectlDelete(t, options, kubeResourcePath)

	k8s.KubectlApply(t, options, kubeResourcePath)

	k8s.WaitUntilServiceAvailable(t, options, "hello-world-service", 10, 1*time.Second)
	service := k8s.GetService(t, options, "hello-world-service")
	url := fmt.Sprintf("http://%s", k8s.GetServiceEndpoint(t, options, service, 5000))

	http_helper.HttpGetWithRetry(t, url, nil, 200, "Hello world!", 30, 3*time.Second)
}
