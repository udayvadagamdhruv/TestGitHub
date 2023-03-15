// This Class is Used to upload CSV/XLS File into Document Object and then will Display file in PDF Format 
public with sharing class FileUploadController 
{
    // Global variables 
    public String theID{get;set;}
    public Document document 
    {
      get 
      {
        if (document == null)
          document = new Document();
        return document;
      }
      set;
    }
    // End of Global variables
    
    // Method called on to create document for uploaded CSV file
    public PageReference upload() 
    {
        if (Schema.sObjectType.Document.fields.AuthorId.isCreateable()){
            document.AuthorId = UserInfo.getUserId();}
        if (Schema.sObjectType.Document.fields.FolderId.isCreateable()){
            document.FolderId = UserInfo.getUserId();} // put it in running user's folder
          //document.ContentType = 'text/plain;charset=UTF-8';  
          //document.body=blob.toPDF(document.body.toString());
          try 
          {
              if(Schema.sObjectType.Document.isCreateable()){   insert document;}
            theID=document.id;
          } 
          catch (DMLException e) 
          {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'));
            return null;
          }
          finally 
          {
             if (Schema.sObjectType.Document.fields.body.isCreateable()){
                 document.body = null;} // clears the viewstate
            document = new Document();
          }
    
    //  ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));
    //  return null;
    
    //   Document doc = [Select Id from Document where id =: theID];
    //   jobid=job.Id;
       
       PageReference p = Page.displayreport;
       p.setredirect(true);
       p.getParameters().put('id',theID); 
       return p;
    }
    // End of method upload
    
    
    // Test Method for DisplayReportExtensionClass     
     static testMethod void Test_displayreportextension()
    {
              Blob b = Blob.valueOf('Test Data'); 
              String fid = UserInfo.getUserId();
              Document testDoc1=new Document(Name='Doc 2',Body=b,FolderId=fid);

              // Instantiate the extention instance with the Custom controller 
              FileUploadController ext=new FileUploadController();
              ext.document = testDoc1;
              
              // Invoke the primary method on the extension             
         
              ApexPages.currentPage().getParameters().put('theID',testDoc1.id);  
             
              ApexPages.PageReference result1=ext.upload();
              
              System.assertEquals('Doc 2',testDoc1.Name);
              
              ext.document=NULL;
             
              result1=ext.upload();
     }
    //End Of Test Method    
}
//End of Class