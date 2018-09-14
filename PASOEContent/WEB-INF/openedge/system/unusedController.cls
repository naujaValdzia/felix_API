 
 /*------------------------------------------------------------------------
    File        : unusedController
    Syntax      : 
    Author(s)   : ppacevicius
    Created     : Wed Sep 05 15:00:55 EEST 2018
    Notes       : 
  ----------------------------------------------------------------------*/
  
@program FILE(name="unusedController.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="unusedController", URI="/unused", schemaName="dsunused", schemaFile="felix_shared/system/i/ds/dsUnused.i").

using Progress.Lang.*.
using Spark.Core.Service.SparkEntity.

block-level on error undo, throw.

class system.unusedController inherits SparkEntity:

    {ds/dsUnused.i}

    constructor public unusedController():

    end constructor.
        
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/getUnused", alias="getUnused", mediaType="application/json").
    
    method public void getUnused (input pcSystem as character,
                                  pcType as character,
                                  output dataset dsunused):
                                      
        define variable unusedService as class UnusedService no-undo.
        unusedService = new UnusedService().
        
        case pcType:
            when "PROCEDURE" then unusedService:getUnusedProcedure(pcSystem, output dataset dsUnused by-reference).
            when "CLASS" then unusedService:getUnusedClass(pcSystem, output dataset dsUnused by-reference).
            when "INCLUDE" then unusedService:getUnusedInclude(pcSystem, output dataset dsUnused by-reference).
            when "ALL" then unusedService:getUnusedAll(pcSystem, output dataset dsUnused by-reference).
        end case.
    end method.
end class.
