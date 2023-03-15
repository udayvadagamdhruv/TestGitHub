// This page is used to create Document from brwosed file bye the User
public with sharing class displayreportextension 
{
    // Start Global variables
   /* public String dipslaytable{get;set;}
    public DateTime today{get;set;}
    String theID;
    public Document d{get;set;}
    public List<Document> lstDoc;
    public String imageBody{get;set;}
    public String imageURL{get;set;}
    public boolean imageNotFound{get;set;}
    // End of Global variables
    public integer sizeoflines {get;set;}
    public list<String> contentlines {get;set;}    
    // Start Constructor
    public displayreportextension(ApexPages.StandardController controller) 
    {
           // Code to display Subscriber Logo 
           // If subscriber deletes the Document : JobSuite_OrganizationLogo from their Org then JobSuite App logo will be displayed
      try{
           
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
         // End of code to display Subscriber Organization Logo
            
          theID = ApexPages.CurrentPage().getParameters().get('id');
          d = [select id,name,Body,ContentType from document where id =: theID];
          System.debug('============Content Type============'+d.ContentType);
          today=System.Today();
          string strOrgId  = UserInfo.getOrganizationId();
         
          dipslaytable=d.body.tostring().striphtmltags();
          

       /*   if(dipslaytable.contains('\r\n')){
          string[] dipslaytablelines=dipslaytable.split('\n');
          sizeoflines =dipslaytablelines.size();
          contentlines=new list<String>();
          for(integer i=0;i<sizeoflines;i++){
           if(dipslaytablelines[i].striphtmltags()!=''){
           contentlines.add(dipslaytablelines[i].striphtmltags());
           }
          }
         }  
          
       }
       
       catch(Exception e){
       
       }   
      
     }*/
     
 
}// End of Class