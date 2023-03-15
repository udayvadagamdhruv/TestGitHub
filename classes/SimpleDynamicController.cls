public with sharing class SimpleDynamicController {

  /*
    //csr__JobDetails__c lst1 = [Select Name,csr__Order__c from csr__JobDetails__c where csr__Selected_Order__c=:true limit 1];
    
    
    public Component.Apex.TabPanel getDynamicDetail() {
         
       
            // Defining all tabs contents here
            Component.Apex.Detail detail = new Component.Apex.Detail();
                    detail.expressions.subject = '{!job}';
                    detail.relatedList = false;
                    detail.title = true;
            component.apex.iframe ifm = new component.apex.iframe();
                    string str = '/apex/DisplayJobTaskInJobTabNew?id='+job.Id;
                    ifm.src= str;//'https://jobsuite.na7.visual.force.com/apex/DisplayJobTaskInJobTabNew?id='+job.id;
                    ifm.scrolling=true;
                    ifm.height='400px';
            component.apex.iframe ifmcb = new component.apex.iframe();
                    string strcb = '/apex/DisplayJobSpecInJobTab?id='+job.Id;
                    ifmcb.src= strcb;
                    ifmcb.scrolling=true;
                    ifmcb.height='400px'; 
            component.apex.iframe ifmQ = new component.apex.iframe();
                    string strQ = '/apex/DisplayQuoteUnderJobTab?id='+job.Id;
                    ifmQ.src= strQ;
                    ifmQ.scrolling=true;
                    ifmQ.height='400px'; 
            component.apex.iframe ifmEst = new component.apex.iframe();
                    string strEst = '/apex/DisplayEstimateunderJobTab?id='+job.Id;
                    ifmEst.src= strEst;
                    ifmEst.scrolling=true;
                    ifmEst.height='400px';
            
            //Defining All Tabs here 
            
                         
            Component.Apex.Tab myTab1 = new Component.Apex.Tab();
            Component.Apex.Tab myTab2 = new Component.Apex.Tab();
            Component.Apex.Tab myTab3 = new Component.Apex.Tab();
            Component.Apex.Tab myTab4 = new Component.Apex.Tab();
            Component.Apex.Tab myTab5 = new Component.Apex.Tab();
            
            //Defining Tab Panel     
            Component.Apex.TabPanel panel = new Component.Apex.TabPanel();
                panel.switchType='client';
                panel.tabClass='activeTab';
                panel.inactiveTabClass='inactiveTab';
            // Component.Apex.c myTab5 = new Component.Apex.c();
            //list<csr__JobDetails__c> lst1 = [Select Name,csr__Order__c from csr__JobDetails__c ];
            Map<Decimal, String> tabMap = new map<Decimal, string>();//[Select csr__Order__c,Name from csr__JobDetails__c]) ;
            //for(csr__JobDetails__c obj: lst1)
            //{
             // tabMap.put(obj.csr__Order__c,obj.Name);
            //}
            tabMap.put(5,'Details');
            tabMap.put(2,'Estimate');
            tabMap.put(3,'Schedule');
            tabMap.put(4,'Quotes');
            tabMap.put(1,'Creative Brief');
            for(Decimal i: tabMap.keySet()) 
                { 
                  if(i == 1)   
                  {
                  myTab1.Label = tabMap.get(i);
                       if(tabMap.get(i) == 'Details')
                       {
                           myTab1.childComponents.add(Detail);
                       }else if(tabMap.get(i) == 'Schedule')
                       {
                           myTab1.childComponents.add(ifm);
                       }else if(tabMap.get(i) == 'Quotes')
                       {
                           myTab1.childComponents.add(ifmQ);
                       }else if(tabMap.get(i) == 'Estimate')
                       {
                           myTab1.childComponents.add(ifmEst);
                       }else if(tabMap.get(i) == 'Creative Brief')
                       {
                           myTab1.childComponents.add(ifmcb);
                       }
                  }else
                   if(i == 2)
                  {
                  myTab2.Label = tabMap.get(i);
                       if(tabMap.get(i) == 'Details')
                       {
                           myTab2.childComponents.add(Detail);
                       }else if(tabMap.get(i) == 'Schedule')
                       {
                           myTab2.childComponents.add(ifm);
                       }else if(tabMap.get(i) == 'Quotes')
                       {
                           myTab2.childComponents.add(ifmQ);
                       }else if(tabMap.get(i) == 'Estimate')
                       {
                           myTab2.childComponents.add(ifmEst);
                       }else if(tabMap.get(i) == 'Creative Brief')
                       {
                           myTab2.childComponents.add(ifmcb);
                       }
                  }else
                   if(i == 3)
                  {
                  myTab3.Label = tabMap.get(i);
                       if(tabMap.get(i) == 'Details')
                       {
                           myTab3.childComponents.add(Detail);
                       }else if(tabMap.get(i) == 'Schedule')
                       {
                           myTab3.childComponents.add(ifm);
                       }else if(tabMap.get(i) == 'Quotes')
                       {
                           myTab3.childComponents.add(ifmQ);
                       }else if(tabMap.get(i) == 'Estimate')
                       {
                           myTab3.childComponents.add(ifmEst);
                       }else if(tabMap.get(i) == 'Creative Brief')
                       {
                           myTab3.childComponents.add(ifmcb);
                       }
                  }else
                   if(i == 4)
                  {
                  myTab4.Label = tabMap.get(i);
                       if(tabMap.get(i) == 'Details')
                       {
                           myTab4.childComponents.add(Detail);
                       }else if(tabMap.get(i) == 'Schedule')
                       {
                           myTab4.childComponents.add(ifm);
                       }else if(tabMap.get(i) == 'Quotes')
                       {
                           myTab4.childComponents.add(ifmQ);
                       }else if(tabMap.get(i) == 'Estimate')
                       {
                           myTab4.childComponents.add(ifmEst);
                       }else if(tabMap.get(i) == 'Creative Brief')
                       {
                           myTab4.childComponents.add(ifmcb);
                       }
                  }else
                   if(i == 5)
                  {
                  myTab5.Label = tabMap.get(i);
                       if(tabMap.get(i) == 'Details')
                       {
                           myTab5.childComponents.add(Detail);
                       }else if(tabMap.get(i) == 'Schedule')
                       {
                           myTab5.childComponents.add(ifm);
                       }else if(tabMap.get(i) == 'Quotes')
                       {
                           myTab5.childComponents.add(ifmQ);
                       }else if(tabMap.get(i) == 'Estimate')
                       {
                           myTab5.childComponents.add(ifmEst);
                       }else if(tabMap.get(i) == 'Creative Brief')
                       {
                           myTab5.childComponents.add(ifmcb);
                       }
                  }
                  }
                  
                   panel.childComponents.add(myTab1);
                   panel.childComponents.add(myTab2);
                   panel.childComponents.add(myTab3);
                   panel.childComponents.add(myTab4);
                   panel.childComponents.add(myTab5);
                  
                  
                  
                  
                  /*   myTab5.Label = tabMap.get(i);
                  }
                  String code = tabMap.get(i);       
                  if(code == 'Details')
                    {
                    myTab1.Label = 'Details';                               
                    myTab1.childComponents.add(detail);
                    myTab1.id = 'tabIndex5000';
                    }
                    else if(code == 'Schedule')
                    {
                    myTab2.Label = 'Schedule';                                   
                    myTab2.childComponents.add(ifm);
                    myTab2.id = 'tabIndex6000';
                    }
                    else if(code == 'Quotes')
                    {
                    myTab3.Label = 'Quotes';                    
                    myTab3.childComponents.add(ifmQ);
                    }
                    else if(code == 'Creative Brief')
                    {
                    myTab4.Label = 'Creative Brief';                    
                    myTab4.childComponents.add(ifmcb);
                    }else
                    {
                    myTab5.Label = 'Estimate';                    
                    myTab5.childComponents.add(ifmEst);
                    }
                    //panel.add
                    
                }*/
          
        
        
        decimal intn;
       /* if(lst1 != Null)
        {
            intn =lst1.csr__Order__c;
        }
        else
        {
            intn = 2;
        }
       if(intn ==1 )
       {
           //Add Tabs in order which u want to dispaly in page
           panel.childComponents.add(myTab1);
           panel.childComponents.add(myTab2);
           panel.childComponents.add(myTab3);
           panel.childComponents.add(myTab4);
           panel.childComponents.add(myTab5);
           //panel.childComponents.add(myTab[i]);
        } 
        else if(intn == 2)
        {
           panel.childComponents.add(myTab1);
           panel.childComponents.add(myTab2);
           panel.childComponents.add(myTab3);
           panel.childComponents.add(myTab4);
           panel.childComponents.add(myTab5);
          
        }else
        {
           panel.childComponents.add(myTab1);
           panel.childComponents.add(myTab2);
           panel.childComponents.add(myTab3);
           panel.childComponents.add(myTab4);
           panel.childComponents.add(myTab5);
        
        }**
        
        return panel;
    }

       
    public Job__c job {
        get { return [SELECT Name FROM Job__c where Name=:'Testcsr1']; }
    }
    public Job_Task__c task {
        get { return [SELECT Name FROM Job_Task__c where Job__c = : job.Name ]; }
    }
*/    
}