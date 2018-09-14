 
 /*------------------------------------------------------------------------
    File        : fileController
    Syntax      : 
    Author(s)   : ppacevicius
    Created     : Wed Sep 05 15:21:30 EEST 2018
    Notes       : 
  ----------------------------------------------------------------------*/
  
@program FILE(name="fileController.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="fileController", URI="/file", schemaName="dsfile", schemaFile="felix_shared/system/i/ds/dsFile.i").

using Progress.Lang.*.
using Spark.Core.Service.SparkEntity.

block-level on error undo, throw.

class system.fileController inherits SparkEntity:

    {ds/dsfile.i}
    {ds/dstree.i}
    {ds/dsFileFiltered.i}


    constructor public fileController():

    end constructor.
    
    /*------------------------------------------------------------------------------
            Purpose:  Get information of item usage: isUsing                                                                     
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/getIsUsingBranch", alias="getIsUsingBranch", mediaType="application/json"). 
    method public void getIsUsingBranch(input pcSystem as character,
                                        input pcFileName as character,
                                        output dataset dsTree):
                
        define variable fileService as class FileService no-undo.
        define variable treeDTO as class TreeDTO no-undo.
        fileService = new FileService().
        fileService:listIsUsing(pcFileName, pcSystem, output dataset dsFile by-reference).
        treeDTO = new TreeDTO().
        treeDTO:fromDomain(dataset dsfile, output dataset dstree by-reference).
    end method.

    /*------------------------------------------------------------------------------
            Purpose:  Get information of item usage: usedBy                                                                        
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/getUsedByBranch", alias="getUsedByBranch", mediaType="application/json"). 
    method public void getUsedByBranch(input pcSystem as character,
                                       input pcFileName as character,
                                       output dataset dsTree):
                
        define variable fileService as class FileService no-undo.
        define variable treeDTO as class TreeDTO no-undo.
        fileService = new FileService().
        fileService:listUsedBy(pcFileName, pcSystem, output dataset dsFile by-reference).
        treeDTO = new TreeDTO().
        treeDTO:fromDomain(dataset dsfile, output dataset dstree by-reference).
    end method.

    /*------------------------------------------------------------------------------
            Purpose:  Get short information of file usage by type:                                                                         
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/getFile", alias="getFile", mediaType="application/json"). 
    method public void getFile(input pcSystem as character,
                               input pcFileName as character,
                               input pcType as character,
                               output dataset dsFileFiltered):
            
        define variable fileService as class FileService no-undo.
        fileService = new FileService().
        
        case pcType:
            when "PROCEDURE" then fileService:findProcedure(pcFileName, pcSystem, output dataset dsFileFiltered by-reference).
            when "CLASS" then fileService:findClass(pcFileName, pcSystem, output dataset dsFileFiltered by-reference).
            when "INCLUDE" then fileService:findInclude(pcFileName, pcSystem, output dataset dsFileFiltered by-reference).
            when "ALL" then fileService:findAllFiles(pcFileName, pcSystem, output dataset dsFileFiltered by-reference).
        end case.
    end method.

    /*------------------------------------------------------------------------------
            Purpose:  Get detailed information of file usage by type:                                                                         
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/getFileDetail", alias="getFileDetail", mediaType="application/json"). 
    method public void getFileDetail(input pcCompileUnit as character,
                                     input pcSystem as character,
                                     input pcType as character,
                                     input pcFileName as character,
                                     output dataset dsFile):
            
        define variable fileService as class FileService no-undo.
        fileService = new FileService().
        case pcType:
            when "PROCEDURE" then fileService:findProcedureDetails(pcCompileUnit, pcFileName, pcSystem, output dataset dsFile by-reference).
            when "CLASS" then fileService:findClassDetails(pcCompileUnit, pcFileName, pcSystem, output dataset dsFile by-reference).
            when "INCLUDE" then fileService:findIncludeDetails(pcCompileUnit, pcFileName, pcSystem, output dataset dsFile by-reference).
            when "ALL" then fileService:findAllFilesDetails(pcCompileUnit, pcFileName, pcSystem, output dataset dsFile by-reference).
        end case.
    end method.
end class.
