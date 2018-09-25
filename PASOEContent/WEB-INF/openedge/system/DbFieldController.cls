 
 /*------------------------------------------------------------------------
    File        : FieldDbController
    Notes       : 
  ----------------------------------------------------------------------*/
  
@program FILE(name="DbFieldController.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="DbFieldController", URI="/dbField", schemaName="dsDbField", schemaFile="felix_shared/system/i/ds/dsDbField.i").

using Progress.Lang.*.
using Spark.Core.Service.SparkEntity.
block-level on error undo, throw.

class system.DbFieldController inherits SparkEntity:
    
    {ds/dsDbField.i}
    {ds/dsDbFieldDto.i}
    define variable dbFieldService as class DbFieldService no-undo.
    
    constructor public DbFieldController ():
        dbFieldService = new DbFieldService().
    end constructor.
   
    /*------------------------------------------------------------------------------
            Purpose:  Get one or more records, containing DB field information
            Notes:
    ------------------------------------------------------------------------------*/
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/getDbField", alias="getDbField", mediaType="application/json"). 
    method public void getDbField(input pcSystem as character,
                                  input pcDbFieldName as character,
                                  input pcType as character,
                                  output dataset dsDbFieldDto):
        dbFieldService:getDbFields(pcDbFieldName, pcSystem, pcType, output dataset dsDbFieldDto by-reference).
    end method.

    /*------------------------------------------------------------------------------
            Purpose:  Get one or more records, containing DB field detailed information
            Notes:
    ------------------------------------------------------------------------------*/
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/getDbFieldDetail", alias="getDbFieldDetail", mediaType="application/json"). 
    method public void getDbFieldDetail(input pcCompileUnit as character,
                                        input pcSystem as character,
                                        input pcDbFieldName as character,
                                        input pcType as character,
                                        output dataset dsDbField):
        dbFieldService:getDbFieldDetails(pcCompileUnit, pcDbFieldName, pcSystem, pcType, output dataset dsDbField by-reference).
    end method.
end class.
