 
 /*------------------------------------------------------------------------
    File        : systemController
    Syntax      : 
    Author(s)   : ppacevicius
    Created     : Wed Sep 05 14:38:56 EEST 2018
    Notes       : 
  ----------------------------------------------------------------------*/
  
@program FILE(name="systemController.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="systemController", URI="/info", schemaName="dssystem", schemaFile="felix_shared/system/i/ds/dsSystem.i").

using Progress.Lang.*.
using Spark.Core.Service.SparkEntity.

block-level on error undo, throw.

class system.systemController inherits SparkEntity:

    {ds/dsSystem.i}

    constructor public systemController():

    end constructor.
    
    /*  Create new system */
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/create", alias="create", mediaType="application/json").
    method public void CreateSystem(input dataset dsSystem):    
        define variable systemService as class SystemService no-undo.
        systemService = new SystemService().
        systemService:createSystem(dataset dsSystem).
    end method. 
    
    /*------------------------------------------------------------------------------
            Purpose:    Delete a record                                                               
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/delete", alias="delete", mediaType="application/json").
    method public void DeleteSystem(input pcSystem as character):                    
        define variable systemService as class SystemService no-undo.
        systemService = new SystemService().
        systemService:deleteSystem(pcSystem).
    end method.
    
    /*  System update */
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/update", alias="update", mediaType="application/json").
    method public void UpdateSystem(input dataset dsSystem):    
        define variable systemService as class SystemService no-undo.
        systemService = new SystemService().
        systemService:updateSystem(dataset dsSystem by-reference).
    end method.
    
    /* Systems list */
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/list", alias="list", mediaType="application/json").
    method public void systemList(output dataset dsSystem):                    
        define variable systemService as class SystemService no-undo.
        systemService = new SystemService().
        systemService:systemList(output dataset dsSystem).
    end method.    

    /* System info */
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/details", alias="details", mediaType="application/json").
    method public void systemInfo(input pcSystem as character,
                                  output dataset dsSystem):
        define variable systemService as class SystemService no-undo.
        systemService = new SystemService().
        systemService:systemInfo(pcSystem, output dataset dsSystem).
    end method.
end class.
