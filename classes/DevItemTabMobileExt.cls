public with sharing class DevItemTabMobileExt {
    
  /*  public String strStatus{get;set;}
    Transient public List<Development_Item__c> lstDev{get;set;}
    public String filterId{get;set;}
    Public integer totalRecs = 0;
    Public integer OffsetSize =0;
    Public integer LimitSize= 50;
    public Integer noOfRecords {set;get;}
    public Integer size {set;get;}
    
    public DevItemTabMobileExt(ApexPages.StandardSetController controller) {
      //  strStatus='All';
        
      /*    if(strStatus == 'All')
          {
              lstDev=[Select Id,Development_Item_Number__c,Name from Development_Item__c ORDER BY Development_Item_Number__c DESC  LIMIT :LimitSize OFFSET :OffsetSize];
              totalRecs = [select count() from Development_Item__c];
             // totalpages=(Integer)((Decimal)totalRecs/blockSize).round(RoundingMode.UP);
          }
          else
          {
              lstDev=[Select Id,Development_Item_Number__c,Name from Development_Item__c where Status__c=:strStatus ORDER BY Development_Item_Number__c  DESC  LIMIT :LimitSize OFFSET :OffsetSize];
              totalRecs = [select count() from Development_Item__c where Status__c= :strStatus];
            //  totalpages=(Integer)((Decimal)totalRecs/blockSize).round(RoundingMode.UP);
          }
       *
    }
    
       public ApexPages.StandardSetController setCon{
        get {
            if(setCon == null) { 
                size=999;               
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [Select Id,Development_Item_Number__c,Name from Development_Item__c ORDER BY Development_Item_Number__c DESC]));
                setCon.setPageSize(size);
                if(filterId!= null)
                {
                  setCon.setFilterId(filterId);
                }
                
                noOfRecords=setCon.getResultSize();
            }            
            return setCon;
        }
        set;
    }
     
    //Changes the size of pagination
    
 
    // Initialize setCon and return a list of record    
     
    public List<Development_Item__c> getDevList() {
         lstDev=(List<Development_Item__c>) setCon.getRecords();
         
         lstDev=[Select Id,Development_Item_Number__c,Name from Development_Item__c Where Id IN:lstDev ORDER BY Development_Item_Number__c DESC];
         return lstDev;
    }
    
    public PageReference RefershPage(){
    setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [Select Id,Development_Item_Number__c,Name from Development_Item__c ORDER BY Development_Item_Number__c DESC]));
                setCon.setPageSize(size);
                if(filterId!= null)
                {
                  setCon.setFilterId(filterId);
                }
                
                return null;
    }
    
    
    
    
    
      public void FirstPage()
    {
        OffsetSize = 0;
        lstDev=[Select Id,Development_Item_Number__c,Name from Development_Item__c Where Id IN:lstDev ORDER BY Development_Item_Number__c DESC LIMIT :LimitSize OFFSET :OffsetSize];
    }
    public void previous()
    {
        OffsetSize = OffsetSize-LimitSize;
        lstDev=[Select Id,Development_Item_Number__c,Name from Development_Item__c Where Id IN:lstDev ORDER BY Development_Item_Number__c DESC LIMIT :LimitSize OFFSET :OffsetSize];
    }
    public void next()
    {
        OffsetSize = OffsetSize+LimitSize;
        lstDev=[Select Id,Development_Item_Number__c,Name from Development_Item__c Where Id IN:lstDev ORDER BY Development_Item_Number__c DESC LIMIT :LimitSize OFFSET :OffsetSize];
    }
    public void LastPage()
    {
        OffsetSize = totalrecs-math.mod(totalRecs,LimitSize);
        lstDev=[Select Id,Development_Item_Number__c,Name from Development_Item__c Where Id IN:lstDev ORDER BY Development_Item_Number__c DESC LIMIT :LimitSize OFFSET :OffsetSize];
    }
    public boolean getprev()
    {
        if(OffsetSize == 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    public boolean getnxt()
    {
        if((OffsetSize + LimitSize) > totalRecs)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    
    */
    
    

}