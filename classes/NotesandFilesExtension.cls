public with sharing class NotesandFilesExtension 
{
    public DateTime today{get;set;}
    String jobid;
    public List<Note> MyNote{get;set;} 
    public List<Attachment> MyFiles{get;set;} 
    public List<Attachment> imagesAttach{get;set;} 
    public List<Attachment> docsAttach{get;set;} 
    public String imageBody{get;set;}
    public String imageURL{get;set;}
    public List<Document> lstDoc;
    public boolean imageNotFound{get;set;}
    public boolean image{get;set;}
  
    // End Global variables

      // Start Constructor
    public NotesandFilesExtension (ApexPages.StandardController controller) 
    {
         // To display Subscriber Organization Logo
         imageURL = '/servlet/servlet.FileDownload?file='; 
        lstDoc = [Select Id, Name, Body from Document where Name =: 'JobSuite_OrganizationLogo' WITH SECURITY_ENFORCED LIMIT 1];
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
            
       jobid = ApexPages.currentpage().getParameters().get('id');
       MyNote = [select id,Title,Body,IsPrivate from Note where parentId=: jobid WITH SECURITY_ENFORCED];
       MyFiles = [select id,name,Body,createddate,ContentType from Attachment where parentId=: jobid WITH SECURITY_ENFORCED order by createddate];
       
       imagesAttach= new list<Attachment>();
       
       docsAttach= new list<Attachment>();
       
       if(myfiles.size()>0)
       {
           for(Attachment a:myfiles)
           {
               if(a.name!=null)
               {
                   if(a.name.contains('.jpg') || a.name.contains('.png') || a.name.contains('.png') || a.name.contains('.jpeg') || a.name.contains('.gif') || a.name.contains('.JFIF') || a.name.contains('.TIF') || a.name.contains('.BMP') )
                   {
                       imagesAttach.add(a);
                   }
                   else
                   {
                       docsAttach.add(a);
                   }
               }
           
           }
       
       }
     
      
       today=System.NOW();
    }



}