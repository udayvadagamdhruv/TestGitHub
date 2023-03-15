public class VFpagesDeletionExt {
    
    public List<VFpageWrapper> VFpageWrapperList;
    public List<Apexpage> pages;
    public List<Apexpage> delpages;
    
    Public class VFpageWrapper
    {
        public Apexpage pag{get;set;}
        public Boolean check{get;set;}
        public VFpageWrapper(Apexpage p)
        {
            pag = p;
            check = false;
        }
        
    }
   
    public VFpagesDeletionExt()
    {
        VFpageWrapperList = new List<VFpageWrapper>();
       
    }
  
    public List<VFpageWrapper> getpages()
    {
        pages = new List<Apexpage>();
        pages = [SELECT Id, Name FROM Apexpage where NOT Description like '%Old%' order by name ASC];
        for(Apexpage pag : pages)
        {
            VFpageWrapperList.add(new VFpageWrapper(pag));
        }
        return VFpageWrapperList;
    }
    
    public void deletepages()
    {
      
        delpages = new List<Apexpage>();
        for(VFpageWrapper c : VFpageWrapperList)
        {
            if(c.check == true)
            {
                delpages.add(c.pag);
                //deploy code from VS code automatically
            }
        }
        try
        {
            //Delete delpages;
        }
        catch(Exception e)
        {
            System.debug('m====='+e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            
        }
    }
}