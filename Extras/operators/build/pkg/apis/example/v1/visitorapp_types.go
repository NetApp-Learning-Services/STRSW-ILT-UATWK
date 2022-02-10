package v1

import (
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

// EDIT THIS FILE!  THIS IS SCAFFOLDING FOR YOU TO OWN!
// NOTE: json tags are required.  Any new fields you add must have json tags for the fields to be serialized.

// VisitorAppSpec defines the desired state of VisitorApp
// +k8s:openapi-gen=true
type VisitorAppSpec struct {
	// INSERT ADDITIONAL SPEC FIELDS - desired state of cluster
	// Important: Run "operator-sdk generate k8s" to regenerate code after modifying this file
	// Add custom validation using kubebuilder tags: https://book-v1.book.kubebuilder.io/beyond_basics/generating_crd.html
	Size  int32  `json:"size"`
	Title string `json:"title"`
}

// VisitorAppStatus defines the observed state of VisitorApp
// +k8s:openapi-gen=true
type VisitorAppStatus struct {
	// INSERT ADDITIONAL STATUS FIELD - define observed state of cluster
	// Important: Run "operator-sdk generate k8s" to regenerate code after modifying this file
	// Add custom validation using kubebuilder tags: https://book-v1.book.kubebuilder.io/beyond_basics/generating_crd.html
	BackendImage  string `json:"backendImage"`
	FrontendImage string `json:"frontendImage"`
}

// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// VisitorApp is the Schema for the visitorapps API
// +kubebuilder:subresource:status
// +kubebuilder:resource:path=visitorapps,scope=Namespaced
type VisitorApp struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`

	Spec   VisitorAppSpec   `json:"spec,omitempty"`
	Status VisitorAppStatus `json:"status,omitempty"`
}

// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// VisitorAppList contains a list of VisitorApp
type VisitorAppList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	Items           []VisitorApp `json:"items"`
}

func init() {
	SchemeBuilder.Register(&VisitorApp{}, &VisitorAppList{})
}
