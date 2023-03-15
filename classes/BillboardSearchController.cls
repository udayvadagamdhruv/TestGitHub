public with sharing class BillboardSearchController {

  /* public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
    } 
   
   
   
    public BillboardSearchController(ApexPages.StandardSetController controller) {
               // Code to display Subscriber Logo
      
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
      // End of Code to display Subscriber Logo
      
      userId=UserInfo.getUserId();
      stBBIds=new Set<Id>();
      List<Billboard__c> lstB=[Select Id from Billboard__c LIMIT 50000];

       
       for(Billboard__c b1:lstB)
       {
          stBBIds.add(b1.Id);
       }
      
       pageNumber = 0;

       totalPageNumber = 0;

       pageSize = 50;
  
       soql = 'select Id, Name,BB_Vendor__r.Name,BB_Vendor__c,Client_Name__r.Name, Client_Name__r.Client_Code__c,Client_Name__c,Expiration_Date__c,Location__c from Billboard__c where name != null';
    
       today=System.NOW();
    
       ViewData();
    }


    public BillboardSearchController(ApexPages.StandardController controller) {
    
    

    }


// Global variables
     
      Map<Id,EntitySubScription> mpJobs;

     public Id userId;
     
     String billboardId; //jobid
     
     public List<Billboard__c> Billboards1{get;set;} //jobs1
     
     Set<Id> stBBIds; //stJobIds;
   
    Transient List<JobWrapper> jobsW{get;set;} // Our collection of the class/wrapper objects JobWrapper 
    
     private String soql {get;set;}       // the soql without the order and limit
     
     private List<Billboard__c> pageBillboards;//pageJobs;
     
     private List<Billboard__c> Billboards;      //jobs  the collection of contacts to display
     
     public String strId{get;set;}

     public Pagereference pg;
    
     private Integer pageNumber;

     private Integer pageSize;

     private Integer totalPageNumber;
     
     public DateTime today{get;set;}
     
     public List<Document> lstDoc;
     
     public String imageBody{get;set;}
     
     public String imageURL{get;set;}
     
     public boolean imageNotFound{get;set;}
     
     // End of Global variables
    
    // This method is used to retrieve pageNumber  
     public Integer getPageNumber()
     {
          return pageNumber;
     }
     // End of method getPageNumber

    // This method is used to retrieve filtered jobs
     public List<Billboard__c> getJobs()
     {
         return pageBillboards;
     }
     // End of method getJobs

    // This method is called on to retrieve number of rows per page
    public Integer getPageSize()
    {
        return pageSize;
    }
    // End of method getPageSize

    // This method is called on check if Previous button to keep in Diable or Enable state
    public Boolean getPreviousButtonEnabled()
    {
        return !(pageNumber > 1);
    }
    // End of method getPreviousButtonEnabled

    // This method is called on check if Next button to keep in Diable or Enable state
    public Boolean getNextButtonDisabled()
    {
        if (Billboards == null) return true;

        else

        return ((pageNumber * pageSize) >= Billboards.size());
    }
    // End of method getNextButtonDisabled

    // This method is called on to retrieve TotalPageNumber
    public Integer getTotalPageNumber()

    {
        if (totalPageNumber == 0 && Billboards!=null)
        {

            totalPageNumber =Billboards.size() / pageSize;

            Integer mod =Billboards.size() - (totalPageNumber * pageSize);

            if (mod > 0)

            totalPageNumber++;

        }
        return totalPageNumber;
    }
    // End of method getTotalPageNumber

        // This method is called on to navigate to Next Search Result layout
    public PageReference nextBtnClick() 
    {
        runQuery(pageNumber+1);

        return null;
    }
    // End of method nextBtn

    // This method is called on to navigate to Previous Search Result layout
    public PageReference previousBtnClick() 
    {
        runQuery( pageNumber - 1);

        return null;
    }
    // End of method previousBtnClick

   // the current sort direction. defaults to asc
    public String sortDir 
    {
        get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
        set;
    }
 
   // the current field to sort by. defaults to last name
   public String sortField {
    get  { if (sortField == null) {sortField = 'Name'; } return sortField;  }
    set;
   }
 
    // format the soql for display on the visualforce page
    public String debugSoql {
    get { return soql + ' order by ' + sortField + ' ' + sortDir + ' limit 10000'; }
    set;
  }    
    
  
  // toggles the sorting of query from asc<-->desc
  public void toggleSort() {
    // simply toggle the direction
    sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
    // run the query again
    runQuery(1);
  }
  
  
   // runs the actual query
  public void runQuery(Integer newPageIndex) 
  {    
      totalPageNumber = 0;
        try 
        {
          
        
        Billboards= Database.query(soql + ' order by ' +  String.escapeSingleQuotes(sortField) + ' ' + String.escapeSingleQuotes(sortDir) + ' limit 100');
        Billboards1= Database.query(soql + ' order by ' +  String.escapeSingleQuotes(sortField) + ' ' + String.escapeSingleQuotes(sortDir) + ' limit 100');

            pageBillboards = new List<Billboard__c >();
    
            Transient Integer counter = 0;

            Transient Integer min = 0;

            Transient Integer max = 0;

            if (newPageIndex > pageNumber)

            {

                min = pageNumber * pageSize;

                max = newPageIndex * pageSize;

            }

            else

            {

                max = newPageIndex * pageSize;

                min = max - pageSize;
            }
      
            for(Billboard__c a : Billboards)

            {
                counter++;

                if (counter > min && counter <= max)

                pageBillboards.add(a);
            }
       
            pageNumber = newPageIndex;
        
            System.debug('Page Number : '+pageNumber);
        
            getPreviousButtonEnabled();
    
            getNextButtonDisabled();
      
        } 
        catch (Exception e) 
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, String.valueOf(e)));
        }
  }
  
     // runs the search with parameters passed via Javascript
  public PageReference runSearch() 
  {
      String Name, clientName,clientCode , vendorName,location,dueDate1, dueDate2;
      Date  dtDueDt1, dtDueDt2;
      
        Name = Apexpages.currentPage().getParameters().get('Name');
    
        clientName = Apexpages.currentPage().getParameters().get('clientName');
        
        clientCode = Apexpages.currentPage().getParameters().get('clientCode');
    
        vendorName= Apexpages.currentPage().getParameters().get('vendorName');
        
        location= Apexpages.currentPage().getParameters().get('location');
    
        
        duedate1= ApexPages.currentPage().getParameters().get('duedt1');
        duedate2= ApexPages.currentPage().getParameters().get('duedt2');
    

        System.debug('Due Date 1 : '+duedate1); 
        System.debug('Due Date 2 : '+duedate2); 

        String s,s1,sNew,sNew1;
        String  strDueDt1, strDueDt2;
        Date d8,d9;
 
       soql = 'select Id, Name,BB_Vendor__r.Name,BB_Vendor__c,Client_Name__r.Name,Client_Name__r.Client_Code__c, Client_Name__c,Expiration_Date__c,Location__c from Billboard__c where name != null';
   
  
       if (!Name.equals(''))
          soql += ' and name LIKE \''+String.escapeSingleQuotes(Name)+'%\'';

       if (!clientName.equals(''))
          soql += ' and Client_Name__r.Name LIKE \''+String.escapeSingleQuotes(clientName)+'%\'';
          
      if (!clientCode.equals(''))
          soql += ' and Client_Name__r.Client_Code__c LIKE \''+String.escapeSingleQuotes(clientCode)+'%\'';    
          
      
       if (!vendorName.equals(''))
          soql += ' and BB_Vendor__r.Name LIKE \''+String.escapeSingleQuotes(vendorName)+'%\'';  
      
        if (!location.equals(''))
          soql += ' and Location__c LIKE \''+String.escapeSingleQuotes(location)+'%\'';  
      
  
        
        if(!dueDate1.equals('') && dueDate1.length() >=8)
        {
           // String[] st3=dueDate1.split('/');
             
            String[] st3;
            Integer d3,m3,y3;
            
            if(isLtng)
            {
                st3=dueDate1.split('-');
                
                y3=Integer.valueOf(st3[0]);
                m3=Integer.valueOf(st3[1]);
                d3=Integer.valueOf(st3[2]);
            }
            else
            {
                st3=dueDate1.split('/');
               
                d3=Integer.valueOf(st3[0]);
                m3=Integer.valueOf(st3[1]);
                y3=Integer.valueOf(st3[2]);
                
            }
            
          /*  Integer d3=Integer.valueOf(st3[0]);
            Integer m3=Integer.valueOf(st3[1]);
            Integer y3=Integer.valueOf(st3[2]);*/
            
      /*      dtDueDt1=Date.newInstance(y3,m3,d3);
            strDueDt1=String.valueOf(dtDueDt1);
            soql+= ' and Expiration_Date__c>= '+String.valueOf(dtDueDt1)+' ';
            
            st3 = NULL;
            m3= NULL;
            d3= NULL;
            y3= NULL; 
        }
        
        if(!dueDate2.equals('') && dueDate2.length() >=8)
        {
          // String[] st4=dueDate2.split('/');
            
           String[] st4; 
           Integer d4,m4,y4; 
            
            if(isLtng)
            {
                st4=dueDate2.split('-');
                
                y4=Integer.valueOf(st4[0]);
                m4=Integer.valueOf(st4[1]);
                d4=Integer.valueOf(st4[2]);
            }
            else
            {
               st4=dueDate2.split('/');
               
               d4=Integer.valueOf(st4[0]);
               m4=Integer.valueOf(st4[1]);
               y4=Integer.valueOf(st4[2]);
            }*/
           
         /*   system.debug('>>>>>>>>>dueDate2>>>>>>>>>>'+dueDate2);
            system.debug('>>>>>>>>>st4>>>>>>>>>>'+st4);
            Integer d4=Integer.valueOf(st4[0]);
            Integer m4=Integer.valueOf(st4[1]);
            Integer y4=Integer.valueOf(st4[2]);*/
        /*    
            dtDueDt2=Date.newInstance(y4,m4,d4);
             system.debug('>>>>>>>>>dtDueDt2>>>>>>>>>>'+dtDueDt2);
            //strDueDt2=String.valueOf(dtDueDt2);
            soql+= ' and Expiration_Date__c <= '+String.valueOf(dtDueDt2)+' ';
            
            st4 = NULL;
            m4= NULL;
            d4= NULL;
            y4= NULL; 
        }
        
         
         
    // run the query again
    runQuery(1);
 
    return null;
  }
 
  

  // This method is called on to navigate user to selected Job
  public pagereference navigate()
  {
      Pagereference pg;
      
        if(isLtng)
        {
           pg=new Pagereference('/apex/apex/BillboardDetailPageLightning?id='+strId);
        }
        else
        {
            pg=new Pagereference('/apex/apex/BillboardDetailPage?id='+strId);
        } 
      
      pg.setRedirect(true);
      return pg;
  }
  // End of method navigate
  
  // This method is called on to create New Job
  public pagereference createNewJob()
  {
        if(isLtng)
        {
            pg=new Pagereference('/apex/CreateNewBillboardLightning');
        }
        else
        {
            pg=new Pagereference('/apex/CreateNewBillboard');
        } 
     
      pg.setRedirect(true);
      return pg;
  }
  // End of method createNewJob
  
  // This method is called on to navigate user to edit Job page
  public pagereference editJob()
  {
        if(isLtng)
        {
            pg=new Pagereference('/apex/EditBillboardLightning?id='+strId);
        }
        else
        {
            pg=new Pagereference('/apex/EditBillboard?id='+strId);
        } 
      
      pg.setRedirect(true);
      return pg;
  }
  // End of method editJob
  
  
 // This method is called on to delete Job
  public pagereference deleteJob()
  {
     pg=new Pagereference('/apex/DeleteBillboard?id='+strId);
     pg.setRedirect(true);
     return pg;
  }
  // End of method deleteJob
 
 

 
 public pagereference viewData()
 {
     Billboards=NULL;
     
     totalPageNumber=0;
     
     runQuery(1);
     
     return NULL;
 }
  
// init the controller and display some sample data when the page loads
  public BillboardSearchController () 
  {
      // Code to display Subscriber Logo
      
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
      // End of Code to display Subscriber Logo
      
      userId=UserInfo.getUserId();
      stBBIds=new Set<Id>();
      List<Billboard__c> lstB=[Select Id from Billboard__c LIMIT 50000];

       
       for(Billboard__c b1:lstB)
       {
          stBBIds.add(b1.Id);
       }
      
       pageNumber = 0;

       totalPageNumber = 0;

       pageSize = 50;
  
       soql = 'select Id, Name,BB_Vendor__r.Name,BB_Vendor__c,Client_Name__r.Name, Client_Name__r.Client_Code__c,Client_Name__c,Expiration_Date__c,Location__c from Billboard__c where name != null';
    
       today=System.NOW();
    
       ViewData();
      
  }
 
    // This is our wrapper/container class.
    
    //In this example a wrapper class contains both the Billborad object Contact and a Boolean value checked
    public class JobWrapper
    {
        public Transient  Boolean checked{get;set;}
        public Transient  Billboard__c objJob{get;set;}
        
        
        public JobWrapper()
        {
            objJob=new Billboard__c();
            checked=false;
        }
        
        //This is the contructor method. We also set the checked value based on user has already followed the record
        public JobWrapper(Billboard__c j,boolean f)
        {
            objJob=j;
            checked=f;
        }
      }  
    
//This method returns List of jobs based on search criteria use has sepcified on layout
    public List<JobWrapper> getJobsW()
    {
        jobsW=new List<JobWrapper>();
       
         mpJobs=new Map<Id,EntitySubscription>();
        
        for(Billboard__c j:pageBillboards)
         
           jobsW.add(new JobWrapper(j,false));
        return jobsW;    
    }


*/

}