public with sharing class JobSearchControllerprint {

     public List<Document> lstDoc;
     
     public String imageBody{get;set;}
     
     public String imageURL{get;set;}
     
     public boolean imageNotFound{get;set;}


   
   
   
   public JobSearchControllerprint() 
  {
   
    imageURL = '/servlet/servlet.FileDownload?file='; 
      lstDoc = [Select Id, Name, Body from Document where Name =: 'JobSuite_OrganizationLogo' LIMIT 1];
      if(!lstDoc.isEmpty())
      {
           String imageId =  lstDoc[0].Id;
           imageBody = imageURL+imageId; 
           imageNotFound = False;
      }    
      else
      {
           imageNotFound = True;
      }
      
      }
}