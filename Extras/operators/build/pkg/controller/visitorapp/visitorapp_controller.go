package visitorapp

import (
	"context"
	"fmt"
	"time"

	examplev1 "github.com/cburchett/visitorapp-operator/pkg/apis/example/v1"
	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
	"k8s.io/apimachinery/pkg/api/errors"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/runtime"
	"sigs.k8s.io/controller-runtime/pkg/client"
	"sigs.k8s.io/controller-runtime/pkg/controller"
	"sigs.k8s.io/controller-runtime/pkg/handler"
	logf "sigs.k8s.io/controller-runtime/pkg/log"
	"sigs.k8s.io/controller-runtime/pkg/manager"
	"sigs.k8s.io/controller-runtime/pkg/reconcile"
	"sigs.k8s.io/controller-runtime/pkg/source"
)

var log = logf.Log.WithName("controller_visitorapp")

/**
* USER ACTION REQUIRED: This is a scaffold file intended for the user to modify with their own Controller
* business logic.  Delete these comments after modifying this file.*
 */

// Add creates a new VisitorApp Controller and adds it to the Manager. The Manager will set fields on the Controller
// and Start it when the Manager is Started.
func Add(mgr manager.Manager) error {
	return add(mgr, newReconciler(mgr))
}

// newReconciler returns a new reconcile.Reconciler
func newReconciler(mgr manager.Manager) reconcile.Reconciler {
	return &ReconcileVisitorApp{client: mgr.GetClient(), scheme: mgr.GetScheme()}
}

// add adds a new Controller to mgr with r as the reconcile.Reconciler
func add(mgr manager.Manager, r reconcile.Reconciler) error {
	// Create a new controller
	c, err := controller.New("visitorapp-controller", mgr, controller.Options{Reconciler: r})
	if err != nil {
		return err
	}

	// Watch for changes to primary resource VisitorApp (the CRD associated with this operator)
	err = c.Watch(&source.Kind{Type: &examplev1.VisitorApp{}}, &handler.EnqueueRequestForObject{})
	if err != nil {
		return err
	}

	/* REMOVED TO ADD CUSTOM WATCH LOGIC
	// TODO(user): Modify this to be the types you create that are owned by the primary resource
	// Watch for changes to secondary resource Pods and requeue the owner VisitorApp

	err = c.Watch(&source.Kind{Type: &corev1.Pod{}}, &handler.EnqueueRequestForOwner{
	   	IsController: true,
	   	OwnerType:    &examplev1.VisitorApp{},
	})
	if err != nil {
	   	return err
	}
	*/

	// Watch for changes to secondary resources (resources created by the operator)
	// In this case, it a Deployment and Service with the owner as this primary resource
	// Don't want to watch for all Deployments and Services
	// Might want to add Secrets, Role, RoleBinding, and ServiceAccount?
	err = c.Watch(&source.Kind{Type: &appsv1.Deployment{}}, &handler.EnqueueRequestForOwner{
		IsController: true,
		OwnerType:    &examplev1.VisitorApp{},
	})
	if err != nil {
		return err
	}

	err = c.Watch(&source.Kind{Type: &corev1.Service{}}, &handler.EnqueueRequestForOwner{
		IsController: true,
		OwnerType:    &examplev1.VisitorApp{},
	})
	if err != nil {
		return err
	}

	return nil
}

// blank assignment to verify that ReconcileVisitorApp implements reconcile.Reconciler
var _ reconcile.Reconciler = &ReconcileVisitorApp{}

// ReconcileVisitorApp reconciles a VisitorApp object
type ReconcileVisitorApp struct {
	// This client, initialized using mgr.Client() above, is a split client
	// that reads objects from the cache and writes to the apiserver
	client client.Client
	scheme *runtime.Scheme
}

// Reconcile reads that state of the cluster for a VisitorApp object and makes changes based on the state read
// and what is in the VisitorApp.Spec
// TODO(user): Modify this Reconcile function to implement your Controller logic.  This example creates
// a Pod as an example
// Note:
// The Controller will requeue the Request to be processed again if the returned error is non-nil or
// Result.Requeue is true, otherwise upon completion it will remove the work from the queue.

// Reconcile is consistent with the declarative model of Kubernetes -
// no add, delete, or update methods
// instead controller passes in current state
// it is up the this method to decide what to do and then do implement it
// this method should be idempotent (can running many times without issues)
func (r *ReconcileVisitorApp) Reconcile(request reconcile.Request) (reconcile.Result, error) {
	reqLogger := log.WithValues("Request.Namespace", request.Namespace, "Request.Name", request.Name)
	reqLogger.Info("Reconciling VisitorApp")

	// Fetch the VisitorApp instance
	// Gets the spec and status fields from the instance
	instance := &examplev1.VisitorApp{}
	//r is the reconciler object with access to the authenticated client
	err := r.client.Get(context.TODO(), request.NamespacedName, instance)
	if err != nil {
		if errors.IsNotFound(err) {
			// Request object not found, could have been deleted after reconcile request.
			// Owned objects are automatically garbage collected. For additional cleanup logic use finalizers.
			// Return and don't requeue
			return reconcile.Result{}, nil
		}
		// Error reading the object - requeue the request.
		return reconcile.Result{}, err
	}

	/*  //REMOVED TO ADD CUSTOM OPERATOR LOGIC
	    // Define a new Pod object
	   	pod := newPodForCR(instance)

	   	// Set VisitorApp instance as the owner and controller
	   	if err := controllerutil.SetControllerReference(instance, pod, r.scheme); err != nil {
	   		return reconcile.Result{}, err
	   	}

	   	// Check if this Pod already exists
	   	found := &corev1.Pod{}
	   	err = r.client.Get(context.TODO(), types.NamespacedName{Name: pod.Name, Namespace: pod.Namespace}, found)
	   	if err != nil && errors.IsNotFound(err) {
	   		reqLogger.Info("Creating a new Pod", "Pod.Namespace", pod.Namespace, "Pod.Name", pod.Name)
	   		err = r.client.Create(context.TODO(), pod)
	   		if err != nil {
	   			return reconcile.Result{}, err
	   		}

	   		// Pod created successfully - don't requeue
	   		return reconcile.Result{}, nil
	   	} else if err != nil {
	   		return reconcile.Result{}, err
	   	}

	   	// Pod already exists - don't requeue
	   	reqLogger.Info("Skip reconcile: Pod already exists", "Pod.Namespace", found.Namespace, "Pod.Name", found.Name)
		return reconcile.Result{}, nil
	*/

	//BEGIN CUSTOM VISITORAPP RECONCILE LOGIC

	// Stores the result of the declarative reconcile operation
	var result *reconcile.Result

	// == MySQL ==========
	result, err = r.ensureSecret(request, instance, r.mysqlAuthSecret(instance))
	if result != nil {
		return *result, err
	}

	result, err = r.ensureDeployment(request, instance, r.mysqlDeployment(instance))
	if result != nil {
		return *result, err
	}

	result, err = r.ensureService(request, instance, r.mysqlService(instance))
	if result != nil {
		return *result, err
	}

	mysqlRunning := r.isMysqlUp(instance)

	if !mysqlRunning {
		// If MySQL isn't running yet, requeue the reconcile
		// to run again after a delay
		delay := time.Second * time.Duration(5)

		log.Info(fmt.Sprintf("MySQL isn't running, waiting for %s", delay))
		return reconcile.Result{RequeueAfter: delay}, nil
	}

	// == Visitors Backend  ==========
	result, err = r.ensureDeployment(request, instance, r.backendDeployment(instance))
	if result != nil {
		return *result, err
	}

	result, err = r.ensureService(request, instance, r.backendService(instance))
	if result != nil {
		return *result, err
	}

	err = r.updateBackendStatus(instance)
	if err != nil {
		// Requeue the request if the status could not be updated
		return reconcile.Result{}, err
	}

	result, err = r.handleBackendChanges(instance)
	if result != nil {
		return *result, err
	}

	// == Visitors Frontend ==========
	result, err = r.ensureDeployment(request, instance, r.frontendDeployment(instance))
	if result != nil {
		return *result, err
	}

	result, err = r.ensureService(request, instance, r.frontendService(instance))
	if result != nil {
		return *result, err
	}

	err = r.updateFrontendStatus(instance)
	if err != nil {
		// Requeue the request
		return reconcile.Result{}, err
	}

	result, err = r.handleFrontendChanges(instance)
	if result != nil {
		return *result, err
	}

	// == Finish ==========
	// Everything went fine, don't requeue
	return reconcile.Result{}, nil

	//END CUSTOM VISITORAPP RECONCILE LOGIC

}

// newPodForCR returns a busybox pod with the same name/namespace as the cr
func newPodForCR(cr *examplev1.VisitorApp) *corev1.Pod {
	labels := map[string]string{
		"app": cr.Name,
	}
	return &corev1.Pod{
		ObjectMeta: metav1.ObjectMeta{
			Name:      cr.Name + "-pod",
			Namespace: cr.Namespace,
			Labels:    labels,
		},
		Spec: corev1.PodSpec{
			Containers: []corev1.Container{
				{
					Name:    "busybox",
					Image:   "busybox",
					Command: []string{"sleep", "3600"},
				},
			},
		},
	}
}
