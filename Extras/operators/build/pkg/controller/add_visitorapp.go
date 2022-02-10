package controller

import (
	"github.com/cburchett/visitorapp-operator/pkg/controller/visitorapp"
)

func init() {
	// AddToManagerFuncs is a list of functions to create controllers and add them to a manager.
	AddToManagerFuncs = append(AddToManagerFuncs, visitorapp.Add)
}
