 
 /*------------------------------------------------------------------------
    File        : fieldDbController
    Syntax      : 
    Author(s)   : ppacevicius
    Created     : Wed Sep 05 15:23:08 EEST 2018
    Notes       : 
  ----------------------------------------------------------------------*/
  
@program FILE(name="fieldDbController.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="fieldDbController", URI="/dbField", schemaName="dsfielddb", schemaFile="felix_shared/system/i/ds/dsDbField.i").

using Progress.Lang.*.
using Spark.Core.Service.SparkEntity.

block-level on error undo, throw.

class system.fieldDbController inherits SparkEntity:

    {ds/dsDbField.i}
    {ds/dsDbFieldFiltered.i}

    constructor public fieldDbController():
    
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
                                  output dataset dsDbFieldFiltered):
            
        define variable fielddbService as class FielddbService no-undo.
        fielddbService = new FielddbService().
        
        case pcType:
            when "ACCESS" then fielddbService:findAccess(pcDbFieldName, pcSystem, output dataset dsDbFieldFiltered by-reference).
            when "UPDATE" then fielddbService:findUpdate(pcDbFieldName, pcSystem, output dataset dsDbFieldFiltered by-reference).
            when "DELETE" then fielddbService:findDelete(pcDbFieldName, pcSystem, output dataset dsDbFieldFiltered by-reference).
            when "REFERENCE" then fielddbService:findReference(pcDbFieldName, pcSystem, output dataset dsDbFieldFiltered by-reference).
            when "INDEX" then fielddbService:findIndex(pcDbFieldName, pcSystem, output dataset dsDbFieldFiltered by-reference).
            when "ALL" then fielddbService:findAllDbFields(pcDbFieldName, pcSystem, output dataset dsDbFieldFiltered by-reference).
        end case.
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
            
        define variable fielddbService as class FielddbService no-undo.
        fielddbService = new FielddbService().
        
        case pcType:
            when "ACCESS" then fielddbService:findAccessDetails(pcCompileUnit, pcDbFieldName, pcSystem, output dataset dsDbField by-reference).
            when "UPDATE" then fielddbService:findUpdateDetails(pcCompileUnit, pcDbFieldName, pcSystem, output dataset dsDbField by-reference).
            when "DELETE" then fielddbService:findDeleteDetails(pcCompileUnit, pcDbFieldName, pcSystem, output dataset dsDbField by-reference).
            when "REFERENCE" then fielddbService:findReferenceDetails(pcCompileUnit, pcDbFieldName, pcSystem, output dataset dsDbField by-reference).
            when "INDEX" then fielddbService:findIndexDetails(pcCompileUnit, pcDbFieldName, pcSystem, output dataset dsDbField by-reference).
            when "ALL" then fielddbService:findAllDbFieldsDetails(pcCompileUnit, pcDbFieldName, pcSystem, output dataset dsDbField by-reference).
        end case.
    end method.
end class.
