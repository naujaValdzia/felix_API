 
 /*------------------------------------------------------------------------
    File        : errorController
    Syntax      : 
    Author(s)   : ppacevicius
    Created     : Wed Sep 05 14:30:07 EEST 2018
    Notes       : 
  ----------------------------------------------------------------------*/
  
@program FILE(name="errorController.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="errorController", URI="/error", schemaName="dserror", schemaFile="felix_shared/system/i/ds/dsError.i").

using Progress.Lang.*.
using Spark.Core.Service.SparkEntity.

block-level on error undo, throw.

class system.errorController inherits SparkEntity:

    {ds/dsError.i}

    constructor public errorController():

    end constructor.
        
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/getError", alias="getError", mediaType="application/json").
    
    method public void getError (input systemName as character,
                                 output dataset dsError):
        define variable errorService as class ErrorService no-undo.
        errorService = new ErrorService().
        errorService:getError(systemName, output dataset dsError).
    end method.
end class.
