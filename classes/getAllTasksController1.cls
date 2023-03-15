public with sharing class getAllTasksController1 {

    //Global variables 
  /*  TRANSIENT public List<Job_Task__c> results {get;set;}
    TRANSIENT public String filterId {get;set;}
    private String sortDirection = 'ASC';
    private String sortExp = 'Job__r.Name';
    //Variables ends here
    
    //Class constructor
    public getAllTasksController1(){
        results = new List<Job_Task__c>();
        filterId = 'Today';
        processRequests();
    }
    //class constructor ends here
    
    //Method to get data on selection of filter value 
    public PageReference processRequests()
    {
        if (filterId == 'Today') {
            results = new List<Job_Task__c>();
            results = [Select Id, Name, Revised_Due_Date__c, Due_Date__c, Assigned_Users__c, Job__r.Name, Job__r.Job_Auto_Number__c, Job__r.Status__c FROM Job_Task__c WHERE Revised_Due_Date__c =: System.Today() AND Job__r.Status__c =:'Active' AND Status__c =:'Active' ORDER BY Job__r.Name limit 1000]; //AND Assigned_Users__c != NULL
        }
        else if(filterId == 'Week'){
            results = new List<Job_Task__c>();
            results = [Select Id, Name, Revised_Due_Date__c, Due_Date__c, Assigned_Users__c, Job__r.Name, Job__r.Job_Auto_Number__c, Job__r.Status__c FROM Job_Task__c WHERE Revised_Due_Date__c >=: System.Today() AND Revised_Due_Date__c <=: System.Today().addDays(6) AND Job__r.Status__c =:'Active' AND Status__c =:'Active' ORDER BY Job__r.Name limit 1000]; //AND Assigned_Users__c != NULL 
        }
        else{
            results = new List<Job_Task__c>();
            results = [Select Id, Name, Revised_Due_Date__c, Due_Date__c, Assigned_Users__c, Job__r.Name, Job__r.Job_Auto_Number__c, Job__r.Status__c FROM Job_Task__c WHERE Revised_Due_Date__c <: System.Today() AND Job__r.Status__c =:'Active' AND Status__c =:'Active' ORDER BY Job__r.Name limit 1000]; //AND Assigned_Users__c != NULL 
        }
        return null;
    }
    //Method ends here

    //Method to add filter values to the page.
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Today', 'Tasks Due Today'));
        options.add(new SelectOption('Week', 'Tasks Due This Week'));
        options.add(new SelectOption('Past', 'Tasks Past Due'));
        return options;
    }
    //Method ends here.
    
    public String sortExpression{
        get{
            return sortExp;
        }
        set{
            // if the columns is clicked on then switch between ascending and descending modes
            if( value == sortExp)
            {
                sortDirection = (sortDirection== 'ASC')?'DESC' : 'ASC';
            }
            else
            {
                sortDirection='ASC';
            } 
            sortExp=value;
        }
    }
    
    public string getSortDirection(){
        // if not columns is selected
        if(sortExpression==NULL || sortExpression=='')
        {
            return 'ASC';
        }
        else
        {
            return sortDirection;
        }
    }
    
    public void setSortDirection(String value){
        sortDirection=value;
    }
    
    //Method to get data based on column sorting.
    public PageReference ViewData(){
        System.debug('filterId --------> ' + filterId);
        string sortFullExp = sortExpression  + ' ' + sortDirection;
        String stat = 'Active';
        if (filterId == 'Today') {
            results = new List<Job_Task__c>();
            results = Database.query('Select Id, Name, Revised_Due_Date__c, Due_Date__c, Assigned_Users__c, Job__r.Name, Job__r.Job_Auto_Number__c, Job__r.Status__c FROM Job_Task__c WHERE Revised_Due_Date__c = ' + String.valueOf(System.Today()) + ' AND Job__r.Status__c =: stat AND Status__c =: stat Order by ' + sortFullExp + ' limit 1000'); //AND Assigned_Users__c != NULL  
        }
        else if(filterId == 'Week'){
            results = new List<Job_Task__c>();
            results = Database.query('Select Id, Name, Revised_Due_Date__c, Due_Date__c, Assigned_Users__c, Job__r.Name, Job__r.Job_Auto_Number__c, Job__r.Status__c FROM Job_Task__c WHERE Revised_Due_Date__c >= ' + String.valueOf(System.Today()) + ' AND Revised_Due_Date__c <= ' + String.valueOf(System.Today().addDays(6)) + ' AND Job__r.Status__c =: stat AND Status__c =: stat Order by ' + sortFullExp + ' limit 1000'); //AND Assigned_Users__c != NULL 
        }
        else{
            results = new List<Job_Task__c>();
            results = Database.query('Select Id, Name, Revised_Due_Date__c, Due_Date__c, Assigned_Users__c, Job__r.Name, Job__r.Job_Auto_Number__c, Job__r.Status__c FROM Job_Task__c WHERE Revised_Due_Date__c < ' + String.valueOf(System.Today()) + ' AND Job__r.Status__c =: stat AND Status__c =: stat Order by ' + sortFullExp + ' limit 1000'); //AND Assigned_Users__c != NULL 
        }
        return null;
    }
    //method ends here. */
}