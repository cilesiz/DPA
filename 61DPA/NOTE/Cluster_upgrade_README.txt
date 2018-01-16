2.1 Prerequisites for upgrade install - Cluster
===============================================

1) Increase the number of file descriptors in the application node in Unix
	 	
The following is the procedure for setting the ulimit. 
This procdure should be executed on both MASTER/SLAVE nodes irrespective of MASTER/SLAVE upgrade.
		
For instance, the following are the steps in CentOS Linux. 
  
a. As root user, edit /etc/sysctl.conf and add the line:
		
   fs.file-max = 512000
		
b. At the prompt, run:
		
   # sysctl -p
   This will cause the settings to take effect. 
		   
c. Edit /etc/security/limits.conf and add the following:
           
   * - nofile 65535
		   
See the inline comments for more details on what this does and how to make it more restrictive if you prefer.
		   
d. As root user, run 
		
   # ulimit -n 65535		
 
Note: It is suggested installation is initiated in the same terminal window after the changes.    


2.2 Upgrade install - Cluster
=============================

The following are the steps for the upgrade installation of the app/ds node.
     
1) Stop the load balancer
  
     # service haproxy stop   
  
2) Wait until the message queues are empty   
    	      
  a. Check the following folder in unix,
	  
     /opt/emc/dpa/services/standalone/data/messaginglargemessages

     If it is empty, go to step 3.		 
			  
  b. If the folder is not empty, run this REST call on both application nodes (MASTER/SLAVE): 
	    
	HTTP Operation : GET
 
	REST URL : http://hostname:9004/dpa-api/support/queues?name=DLQ 
		 	       
     The output should include a line such as the following:
 		 
	 <currentTotalMessageCount>21</currentTotalMessageCount> 	          
	  	   
     Here, for instance, this number (21) should match the number of files in the messaginglargemessages folder
		 
	 /opt/emc/dpa/services/standalone/data/messaginglargemessages

     If the number of files does not match, wait until the messaging queue becomes empty.		 
	
   
3) Stop and demote the application nodes
    
   a. Stop the Application Servers
	  
    # dpa app stop
		
   b. Demote each application cluster node to a non-clusterable state.
	
    # dpa app dem	    
  
4) Stop the DataStore master and data store slaves in case of replication 
      
5) Upgrade the DS and data store slaves if applicable
   
6) Stop the Data stores again
   
7) Set the database connection pool size in all the data store nodes
   
     # dpa ds tune --connections xxx <RAM>GB
		
     Where xxx is roughly (150* number of AS), so, 300 for a 2-node cluster
        
     Note: If the cluster is enabled with data store replication, this step (tune) needs to also be applied to all data store slaves.		 
		 
8) Start the data store node(s)

     # dpa ds start 
		
9) Upgrade the MASTER application node
  
  a. The installer starts the services automatically after upgrade. 
     Wait for the application service to be deployed completely. 
		
  b. Manually stop the AS
	   
      # dpa app stop

  c. Promote the AS node to a clusterable state ('dpa app promote --role MASTER --bind <MASTER_IP> --path <Path to network share>')
 
      # dpa app pro --role MASTER --bind 10.64.213.217 --path /nfsshare  
 
  d. Start the app node.
	 
      # dpa app start

  e. Wait until the MASTER node has started successfully		  
	   
	   
10) Upgrade the other application nodes (SLAVES)
  
  a. The installer starts the services automatically after upgrade. 
     Wait for the application service to be deployed completely. 

  b. Manually stop the AS
	   
      # dpa app stop

  c. Promote the AS node to a clusterable state ('dpa app promote --role SLAVE <MASTER_IP> --bind <SLAVE_IP> --path <Path to network share>')
 
     # dpa app pro --role SLAVE 10.64.213.217 --bind 10.64.213.218 --path /nfsshare		  
 
  d. Start the node.
	 
     # dpa app start

  e. Wait until all the SLAVE nodes have started successfully	
  
11) Start up the load balancer
  		 
		 
3. Post install configurations 
==============================

  The following configuration should be applied after the upgrade installation.
  
3.1) Report concurrency settings

   After the installation, login to DPA UI -> Admin ->System-> Configure Report Settings -> Concurrency
	
	 Set the "Maximum Concurrent Reports per Application server" to 6 for the cluster.
