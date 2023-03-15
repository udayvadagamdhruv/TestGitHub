<aura:application extends="force:slds">
  <!-- Create attribute to store lookup value as a sObject--> 
   <aura:attribute name="selectedLookUpRecord" type="sObject" default="{'sObjectType':'Media_Type__c','Id':'a053600000eA9MGAA0' , 'Name':'2018 1Qtr Promos'}" />
   <aura:attribute name="DepenselectedLookUpRecord" type="sObject" default="{}" />  
    
  <aura:attribute name="selectedLookUpRecordClinet" type="sObject" default="{}" />
  <aura:attribute name="DepenselectedLookUpRecordContact" type="sObject" default="{}" />  
    
 <!--
  <c:customLookup objectAPIName="Media_Type__c" DepobjectAPIName="Schedule_Template__c" IconName="standard:account" DepIconName="standard:contact" selectedRecord="{!v.selectedLookUpRecord}" 
                  DepenselectedRecord="{!v.DepenselectedLookUpRecord}" label="Media Type" Depelabel="Schedule Template" RelationShipName="Media_Types__c" ParentFilter=""  ChildFilter="Active__c=True"
                  ParentSortBy="Order By Name" ChildSortBy="Order By Name" />
    
    
   
  
   <c:customLookup objectAPIName="Client__c" DepobjectAPIName="Client_Contact__c" IconName="standard:account" DepIconName="standard:contact" selectedRecord="{!v.selectedLookUpRecordClinet}" 
                  DepenselectedRecord="{!v.DepenselectedLookUpRecordContact}" label="Client" Depelabel="Client Contact" RelationShipName="Client__c" ParentFilter="Active__c=true"  ChildFilter="Active__c=True"
                  ParentSortBy="Order By Name" ChildSortBy="Order By Name" /> 
    
    
    <br/><br/>
    
    
    -->
    <lightning:listView aura:id="listViewAccounts"
                        objectApiName="Job__c"
                        listName="All"
                        rows="10"
                        showSearchBar="true"
                        showActionBar="true"
                        enableInlineEdit="true"
                        showRowLevelActions="true"
                        /> 
    <!-- <c:Task_CalenderView/> -->
    
    <!-- <c:Search_Jobs/> --> <c:User_Detail/> 
    
 <!-- here c: is org. namespace prefix-->
</aura:application>