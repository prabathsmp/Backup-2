#!/usr/bin/perl

#**************************************************************************************************************************
#// Copyright 2011 TOSHIBA TEC CORPORATION All rights reserved //

#* $Workfile: Build_Automation_Impr.pl
#* $Revision: 1 $
#* $Date: 06/15/2011$
#* Authors: Siva Sankar A(TESI AL Team)
#*****************************************************************************************************************************/
use MIME::Lite;
use File::Find;
use FindBin '$Bin';
use Switch;
use Cwd 'abs_path';
use Term::ANSIColor;
use Proc::ProcessTable;

use strict;

my $SUB_WORKSET = "EBX:$ARGV[0]";
#my $WORKSET = "INTEG_L471_BASE_REL_WS";
my $WORKSET = "INTEG_COMMON_BASE_REL_WS";
my $COMPILE_PATH = $ARGV[1];
my $EBX_PRODUCT = substr($WORKSET,0,index($WORKSET,'_'));
#my $PRODUCT = substr($EBX_PRODUCT,index($EBX_PRODUCT,'-')+1);
my $PRODUCT = $ARGV[2];
system("export PRODUCT=\$PRODUCT");

#Help Suggestions
my $ARG1 = "INTEG_BP2_SUB_REL_WS";
my $ARG2 = "`pwd`";
my $ARG3 = "BP2";

#my $TO_ADDRESS = "AL\@toshiba-tsip.com,Kapilraj.Kamat\@toshiba-tsip.com";
#my $FROM_ADDRESS = "sivasankar.alluru\@toshiba-tsip.com";

#my $TO_ADDRESS = "AL-Plugin\@toshiba-tsip.com";
my $TO_ADDRESS = "Prabath.Muthusamy\@toshiba-tsip.com";
my $FROM_ADDRESS = "Compilation.Confirmation\@toshiba-tsip.com";

my $compStartTime;
my $compEndTime;
 
my @DEV_DOC_FILES = (
"05_Implement/SYSROM_SRC/dev/AL/Network/DSM/Library/Makefile",
"05_Implement/SYSROM_SRC/dev/AL/Stage2/Test/DotNetTestClient/Properties/Settings.settings",
"05_Implement/SYSROM_SRC/dev/CI/LogManager/testLog/Makefile",
"05_Implement/SYSROM_SRC/LayerInterface/CI/BoxDocument/boxarchive.xsd",
"05_Implement/SYSROM_SRC/LayerInterface/CI/PriorityManager/pmclient.h",
"05_Implement/SYSROM_SRC/dev/AL/Network/DSM/TestClient/MakefileUnittest",
"05_Implement/SYSROM_SRC/build/common/bin/install_tar.sh",
"05_Implement/SYSROM_SRC/dev/AL/Network/DSM/Library/dsp/MakefileUnitTest",
"05_Implement/SYSROM_SRC/dev/AL/Network/DSM/Library/wsm/MakefileUnitTest",
"05_Implement/SYSROM_SRC/dev/AL/Network/DSM/Library/wsp/MakefileUnitTest",
"05_Implement/SYSROM_SRC/LayerInterface/SL/SystemInformation/SystemInfo.xsd",
"05_Implement/SYSROM_SRC/LayerInterface/SL/JobManagement/Jobs.xsd",
"05_Implement/SYSROM_SRC/ComponentInterface/AL/DeviceInformationManager/Configuration/ReportingDeltaDoc.xsd",
"05_Implement/SYSROM_SRC/dev/AL/Stage2/Test/DotNetTestClient/Properties/Settings.Designer.cs",
"05_Implement/SYSROM_SRC/ComponentInterface/AL/DeviceInformationManager/Configuration/FactoryDefaultDeltaDoc.xsd",
"05_Implement/SYSROM_SRC/dev/AL/Stage2/Test/DotNetTestClient/Properties/AssemblyInfo.cs",
"05_Implement/SYSROM_SRC/dev/AL/Stage2/UnitTest/Stage2Responder.txt",
"05_Implement/SYSROM_SRC/dev/AL/Stage2/UnitTest/run_server_rbac",
"05_Implement/SYSROM_SRC/build/common/bin/networkservice/dsm",
"05_Implement/SYSROM_SRC/dev/AL/Stage2/UnitTest/run_server_rbac.sh",
"05_Implement/SYSROM_SRC/ComponentInterface/AL/DeviceInformationManager/Configuration/DiagnosticGetList.xsd",
"05_Implement/SYSROM_SRC/ComponentInterface/AL/SoftwareFunction/IntegrityCheck/IntegrityCheck.xsd",
"05_Implement/SYSROM_SRC/dev/AL/Stage2/UnitTest/runebx",
"05_Implement/SYSROM_SRC/LayerInterface/SL/AgentResourceManagement/AgentStates.xsd",
"05_Implement/SYSROM_SRC/build/common/bin/allinkStateCheck.sh",
"05_Implement/SYSROM_SRC/LayerInterface/SL/WorkflowExecution/EmailParameter.xsd",
"05_Implement/SYSROM_SRC/ComponentInterface/AL/SoftwareFunction/ServiceUIPlugin/ServieUIStructure.xsd",
"05_Implement/SYSROM_SRC/dev/AL/Stage2/Test/DotNetTestClient/Properties/Resources.Designer.cs",
"05_Implement/SYSROM_SRC/ComponentInterface/AL/Reporting/Reporting.xsd",
"05_Implement/SYSROM_SRC/ComponentInterface/AL/SoftwareFunction/IntegrityCheck/IntegrityCheckCommands.xsd",
"05_Implement/SYSROM_SRC/ComponentInterface/AL/DeviceInformationManager/Configuration/EWBSettings.xsd",
"05_Implement/SYSROM_SRC/LayerInterface/SL/WorkflowExecution/EfilingParameter.xsd",
"05_Implement/SYSROM_SRC/LayerInterface/CommonType.xsd",
"05_Implement/SYSROM_SRC/LayerInterface/SL/WorkflowExecution/FilingParameter.xsd",
"05_Implement/SYSROM_SRC/LayerInterface/SL/WorkflowExecution/DiagnosisParameter.xsd",
"05_Implement/SYSROM_SRC/dev/AL/Stage2/Test/DotNetTestClient/Properties/Resources.resx",
"05_Implement/SYSROM_SRC/LayerInterface/SL/WorkflowExecution/ColorParameter.xsd",
"05_Implement/SYSROM_SRC/ComponentInterface/AL/SoftwareFunction/DevAuthMgmtPlugIn/SystemOption.xsd",
"05_Implement/SYSROM_SRC/LayerInterface/SL/DeviceConfiguration/ClearConfigInfo.xsd",
"05_Implement/SYSROM_SRC/ComponentInterface/AL/SoftwareFunction/GroupManager/GroupManager.xsd",
"05_Implement/SYSROM_SRC/LayerInterface/SL/WorkflowExecution/ImageAdjustmentParameter.xsd",
"05_Implement/SYSROM_SRC/LayerInterface/SL/WorkflowExecution/IfaxParameter.xsd",
"05_Implement/SYSROM_SRC/ComponentInterface/AL/Network/DSM/DSM-PluginCommands.xsd",
"05_Implement/SYSROM_SRC/build/common/bin/Master_Bp.csv",
"05_Implement/SYSROM_SRC/LayerInterface/SL/WorkflowExecution/OwnerInformation.xsd",
"05_Implement/SYSROM_SRC/LayerInterface/CI/LogManager/JobLog.xsd",
"05_Implement/SYSROM_SRC/ComponentInterface/AL/JobControllers/CurrentWorkflowInformation.xsd",
"05_Implement/SYSROM_SRC/LayerInterface/SL/WorkflowExecution/FaxParameter.xsd",
"05_Implement/SYSROM_SRC/build/common/bin/Master_Mash.csv",
"05_Implement/SYSROM_SRC/ComponentInterface/AL/SoftwareFunction/RbacManager/RbacManager.xsd",
"05_Implement/SYSROM_SRC/LayerInterface/CI/PresentationResources/PRM.xsd",
"05_Implement/SYSROM_SRC/LayerInterface/SL/WorkflowExecution/WorkflowPolicy.xsd",
"05_Implement/SYSROM_SRC/ComponentInterface/AL/DeviceInformationManager/Configuration/ICCProfileAdvanced.xsd",
"05_Implement/SYSROM_SRC/LayerInterface/SL/WorkflowExecution/ScanParameter.xsd",
"05_Implement/SYSROM_SRC/ComponentInterface/AL/Network/DSM/DSM-Plugin.xsd",
"05_Implement/SYSROM_SRC/dev/AL/Stage2/UnitTest/Changes and Procedures for Unit testing.docx",
"05_Implement/SYSROM_SRC/LayerInterface/SL/WorkflowExecution/WorkflowExecutionParameter.xsd",
"05_Implement/SYSROM_SRC/LayerInterface/SL/WorkflowExecution/FaxParameter.xsd",
"05_Implement/SYSROM_SRC/build/common/bin/Master_Mash.csv",
"05_Implement/SYSROM_SRC/ComponentInterface/AL/SoftwareFunction/RbacManager/RbacManager.xsd",
"05_Implement/SYSROM_SRC/LayerInterface/CI/PresentationResources/PRM.xsd",
"05_Implement/SYSROM_SRC/LayerInterface/SL/WorkflowExecution/WorkflowPolicy.xsd",
"05_Implement/SYSROM_SRC/ComponentInterface/AL/DeviceInformationManager/Configuration/ICCProfileAdvanced.xsd",
"05_Implement/SYSROM_SRC/LayerInterface/SL/WorkflowExecution/ScanParameter.xsd",
"05_Implement/SYSROM_SRC/ComponentInterface/AL/Network/DSM/DSM-Plugin.xsd",
"05_Implement/SYSROM_SRC/dev/AL/Stage2/UnitTest/Changes and Procedures for Unit testing.docx",
"05_Implement/SYSROM_SRC/LayerInterface/SL/WorkflowExecution/WorkflowExecutionParameter.xsd",
"05_Implement/SYSROM_SRC/LayerInterface/SL/DeviceServiceInformation/DeviceFaxEvent.xsd",
"05_Implement/SYSROM_SRC/dev/AL/Stage2/UnitTest/Changes and Procedures for Unit testing and RBACtool testing.docx",
"05_Implement/SYSROM_SRC/LayerInterface/SL/AgentResourceManagement/AgentRestriction.xsd",
"05_Implement/SYSROM_SRC/ComponentInterface/AL/JobControllers/JobControllerCommands.xsd",
"05_Implement/SYSROM_SRC/ComponentInterface/AL/SoftwareFunction/LogManager/LogManager.xsd",
"05_Implement/SYSROM_SRC/LayerInterface/SL/DeviceServiceInformation/ICCProfile.xsd",
"05_Implement/SYSROM_SRC/ComponentInterface/AL/SoftwareFunction/GroupManager/GroupManagerCommands.xsd",
"05_Implement/SYSROM_SRC/LayerInterface/AL/SoftwareFunction/SecurityExportImportLibrary/ExportImport_Combined.xsd",
"05_Implement/SYSROM_SRC/LayerInterface/SL/WorkflowExecution/CommonType.xsd",
"05_Implement/SYSROM_SRC/LayerInterface/SL/WorkflowExecution/PrintParameter.xsd",
"05_Implement/SYSROM_SRC/ComponentInterface/AL/SoftwareFunction/LogManager/LogManagerCommands.xsd",
"05_Implement/SYSROM_SRC/LayerInterface/SL/JobManagement/WorkflowInformationList.xsd",
"05_Implement/SYSROM_SRC/LayerInterface/SL/DeviceServiceInformation/DeviceServiceCounters.xsd",
"05_Implement/SYSROM_SRC/ComponentInterface/AL/SoftwareFunction/RbacManager/RbacManagerCommands.xsd",
"05_Implement/SYSROM_SRC/LayerInterface/SL/DeviceServiceInformation/DeviceStatus.xsd",
"05_Implement/SYSROM_SRC/ComponentInterface/AL/Network/Network.xsd",
"05_Implement/SYSROM_SRC/LayerInterface/SL/DeviceServiceInformation/DeviceServiceCommands.xsd",
"05_Implement/SYSROM_SRC/LayerInterface/SL/DeviceConfiguration/DeviceConfiguration.xsd",
"05_Implement/SYSROM_SRC/build/common/bin/DefaultPrivateArea.xml"
);
my %alBinaries = (
		"albotest" => "AL/SoftwareFunction/Utility/DeltaModifier",
		"aldocread" => "AL/SoftwareFunction/Utility/DocRead",
		"aldocwrite" => "AL/SoftwareFunction/Utility/DocWrite",
		"aldeviceuuidgen" => "AL/SoftwareFunction/Utility/DeviceUUIDGen",
		"alimportdb" => "AL/SoftwareFunction/Utility/ImportDB",
		"alsetdefaultlocale" => "AL/SoftwareFunction/Utility/SetInitialLocale",
		"alViewPlugin" => "AL/SoftwareFunction/ViewPlugin",
		"aljobtemplatemgr" => "AL/SoftwareFunction/JobTemplates",
		"aleFilingmgr" => "AL/SoftwareFunction/eFiling",
		"almailboxapplication" => "AL/SoftwareFunction/MailBox",
		"alServiceUIPlugin" => "AL/SoftwareFunction/ServiceUIPlugin",
		"alusbmscapplication" => "AL/SoftwareFunction/USBApplication",
		"alpresentationresourcemgr" => "AL/SoftwareFunction/PresentationResourceManager",
		"alPanelUIMessageHandler" => "AL/SoftwareFunction/PanelUIMessageHandler",
		"alfilestoragem" => "AL/Maintenance/FileStorageManager",
		"alreportsmsgr" => "AL/Reporting/ReportsMessenger",
		"alreportmanager" => "AL/Reporting/ReportManager",
		"alAddressBookMgr" => "AL/SoftwareFunction/AddressBook",
		"aljobcontroller" => "AL/JobController",
		"alprintmn" => "AL/PrintJobManager",
		"alstage2" => "AL/Stage2"
		);

my %alLibs = (
		"libcimfputility.so.0" => "CI/MfpUtility",
		"libcipmclient.so.0" => "CI/PriorityManager",
		"libcicodecs.so.0" => "CI/Codecs",
		"libciresourcem.so.0" => "CI/PresentationResources",
		"libalusbinterface.so.0" => "AL/SoftwareFunction/USBApplication/USBInterface",
		"libiniparser.so.0" => "AL/SoftwareFunction/Utility/iniparser",
		"libaldiagnosticlib.so.0" => "AL/SoftwareFunction/Utility/DiagnosticLibrary",
		"libalfrontpanel.so.0" => "AL/FrontPanel/FrontPanelLib",
		"libaladdressbookmgr.so.0" => "AL/SoftwareFunction/AddressBookLibrary",
		"libalviewplugin.so.0" => "AL/SoftwareFunction/ViewPlugin/ViewPluginLib",
		"libalsecurepdf.so.0" => "AL/SoftwareFunction/SecurePDFLibrary",
		"mod_contentwebserver.so.0" => "AL/ApplicationServers/ContentWebServer",
		"libconditionparser.so.0" => "AL/SoftwareFunction/Utility/ConditionParser",
		"libalworkflowdatalist.so.0" => "AL/JobController/WorkFlowDataList",
		"libalsessiondatalist.so.0" => "AL/JobController/SessionDataList",
		"libalparameterhandler.so.0" => "AL/JobController/ParameterHandler",
		"libalspooler.so.0" => "AL/Spooler",
    "libaltaprn.so.0" => "AL/Spooler(taprn)",
		"libalstage2.so.0" => "AL/Stage2/Stage2Library"
	     );

my @Dirs = (
		
		"FI /WORKSET=\"$WORKSET\" /FILENAME=\"05_Implement/SYSROM_SRC/dev/AL/status.h\" /USER_FILENAME=\"$COMPILE_PATH/05_Implement/SYSROM_SRC/dev/AL/status.h\" /NOEXPAND - /OVERWRITE",

		"DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/LayerInterface\" /WORKSET=\"$WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",


		"DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/ComponentInterface/AL\" /WORKSET=\"$WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",

		"DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/dev/CI/HierarchicalDB\" /WORKSET=\"$WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",
		"DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/dev/CI/MfpUtility\" /WORKSET=\"$WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",
		"DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/dev/CI/PriorityManager\" /WORKSET=\"$WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",
		
		"DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/dev/CI/PresentationResources\" /WORKSET=\"$WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",
		"DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/dev/CI/Codecs\" /WORKSET=\"$WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",

		#"DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/dev/CI/PDLOptimiser\" /WORKSET=\"$WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",

		"DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/dev/AL/UIController\" /WORKSET=\"$WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",

		"DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/dev/AL/ApplicationServers/ContentWebServer\" /WORKSET=\"$WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",

		"DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/dev/AL/Maintenance/FileStorageManager\" /WORKSET=\"$WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",

		"DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/dev/AL/Reporting\" /WORKSET=\"$WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",

		"DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/dev/AL/JobController\" /WORKSET=\"$WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",

		"DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/dev/AL/SoftwareFunction\" /WORKSET=\"$WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",
		
		"DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/dev/AL/FrontPanel/FrontPanelLib\" /WORKSET=\"$WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",

		"DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/dev/AL/Utility\" /WORKSET=\"$WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",

		"DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/dev/AL/PrintJobManager\" /WORKSET=\"$WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",

		"DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/dev/AL/Spooler\" /WORKSET=\"$WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",

		"DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/ThirdParty/gsoap\" /WORKSET=\"$WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",
		
		"DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/dev/AL/Stage2\" /WORKSET=\"$WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",

		"DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/Resources_Common/COMMON\" /WORKSET=\"$WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",

		"DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/NoBuildItems/AL/SoftwareFunction/JobTemplates\" /WORKSET=\"$WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",

);

my @DirsSub = (

                "FI /WORKSET=\"$SUB_WORKSET\" /FILENAME=\"05_Implement/SYSROM_SRC/dev/AL/status.h\" /USER_FILENAME=\"$COMPILE_PATH/05_Implement/SYSROM_SRC/dev/AL/status.h\" /NOEXPAND - /OVERWRITE",

                "DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/LayerInterface\" /WORKSET=\"$SUB_WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",


                "DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/ComponentInterface/AL\" /WORKSET=\"$SUB_WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",

                "DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/dev/CI/HierarchicalDB\" /WORKSET=\"$SUB_WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",
                "DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/dev/CI/MfpUtility\" /WORKSET=\"$SUB_WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",
                
		"DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/dev/CI/PresentationResources\" /WORKSET=\"$SUB_WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",
		"DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/dev/CI/Codecs\" /WORKSET=\"$SUB_WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",

                #"DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/dev/CI/PDLOptimiser\" /WORKSET=\"$SUB_WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",

                "DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/dev/AL/UIController\" /WORKSET=\"$SUB_WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",

                "DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/dev/AL/ApplicationServers/ContentWebServer\" /WORKSET=\"$SUB_WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",

                "DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/dev/AL/Maintenance/FileStorageManager\" /WORKSET=\"$SUB_WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",

                "DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/dev/AL/Reporting\" /WORKSET=\"$SUB_WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",

                "DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/dev/AL/JobController\" /WORKSET=\"$SUB_WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",

                "DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/dev/AL/SoftwareFunction\" /WORKSET=\"$SUB_WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",

                "DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/dev/AL/FrontPanel/FrontPanelLib\" /WORKSET=\"$SUB_WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",

                "DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/dev/AL/Utility\" /WORKSET=\"$SUB_WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",

                "DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/dev/AL/PrintJobManager\" /WORKSET=\"$SUB_WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",

                "DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/dev/AL/Spooler\" /WORKSET=\"$SUB_WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",

                "DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/ThirdParty/gsoap\" /WORKSET=\"$SUB_WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",

                "DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/dev/AL/Stage2\" /WORKSET=\"$SUB_WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",

                "DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/Resources_Common\" /WORKSET=\"$SUB_WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",

		"DOWNLOAD /DIRECTORY=\"05_Implement/SYSROM_SRC/NoBuildItems\" /WORKSET=\"$SUB_WORKSET\" /USER_DIRECTORY=\"$COMPILE_PATH\" /OVERWRITE",

);

sub DOWNLOAD 
{
	my $Dir;

	print "Downloading files from DIM 10..\n";

	if( "$WORKSET" eq "" || $COMPILE_PATH eq "")
	{
		print  "-------------------------------------";
		print "No workset (OR) Compile Path Specified";                
		print  "-------------------------------------";
		exit 0;
	}

	open (MYFILE, '>commands');
	foreach $Dir (@Dirs)
	{
		print MYFILE $Dir, "\n";
	}
	close (MYFILE); 

	system("/opt/serena/dimensions/10.1/cm/prog/dmcli -con ebx_DIM10_New -user asivasankar -pass Toshiba1 -file commands > pvcs.log 2>&1");
  
	system("cat pvcs.log | grep DEV_DOC | sed -e s/using.*// -e s/^.*05_/05_/ -e s/\\'// -e /^[^0]/d -e /^\$/d > DEV_DOC.txt");

	open(FILE,"pvcs.log");
	if(grep{/Error:|Session\ Expired/} <FILE>)
	{
		close FILE;

		print "Error in downloading files from DIM10\n";

		exit 0;
	}
	
	if(grep{/Warning:/} <FILE>)
	{
		print "Warnings found in DIM10 log(pvcs.log).Please check!!!!!!";
	}     

	#system("rm -f pvcs.log");

	system("rm -f commands");

	print "Completed\n";
}

sub DOWNLOAD_SUB
{
  my $Dir;

  print "Downloading SUB_REL_WS files from DIM 10..\n";

  if( "$SUB_WORKSET" eq "" || $COMPILE_PATH eq "")
  {
    print  "-------------------------------------";
    print "No workset (OR) Compile Path Specified";
    print  "-------------------------------------";
    exit 0;
  }

  open (MYFILE, '>commands');
  foreach $Dir (@DirsSub)
  {
    print MYFILE $Dir, "\n";
  }
  close (MYFILE);

  system("/opt/serena/dimensions/10.1/cm/prog/dmcli -con ebx_DIM10_New -user asivasankar -pass Toshiba1 -file commands > pvcs_sub.log 2>&1");

  system("cat pvcs.log | grep DEV_DOC | sed -e s/using.*// -e s/^.*05_/05_/ -e s/\\'// -e /^[^0]/d -e /^\$/d > DEV_DOC.txt");

  open(FILE,"pvcs_sub.log");
  if(grep{/Error:|Session\ Expired/} <FILE>)
  {
    close FILE;

    print "Error in downloading some files from DIM10 SUB_REL-WS, But this is fine. Continue...\n";

    #exit 0;
  }
    
    if(grep{/Warning:/} <FILE>)
    {
	print "Warnings found in DIM10 log(pvcs.log).Please check!!!!!!";
    }
    
    
    system("rm -f commands");
    
    print "Completed\n";
}

#Overwrite downloaded files to base SYSROM_SRC folder.
sub COPY 
{
	print "Copying latest files to SYSROM_SRC folder..\n";

	my $REL_WS_FILES_PATH = "$COMPILE_PATH/05_Implement/SYSROM_SRC";

	`cp -R -f "$REL_WS_FILES_PATH" "$COMPILE_PATH"`

}


sub THIRD_PARTY_SETUP
{
	system("cd $COMPILE_PATH/SYSROM_SRC/ThirdParty/gsoap/ && make clean all");	
}

sub COMPILE
{
	$compStartTime = localtime();

	print "Compilation Started..Start Time:",$compStartTime . "\n";

	my $SRC_FILES_PATH = "$COMPILE_PATH/SYSROM_SRC";
	if(-d $SRC_FILES_PATH)
	{
		$ENV{'PRODUCT'} = $PRODUCT;#substr($EBX_PRODUCT,index($EBX_PRODUCT,'-')+1);

		chdir "$SRC_FILES_PATH";

		if(-e "$COMPILE_PATH/SYSROM_SRC/dev/AL/AL_Build.log")
		{
			system("rm -rf $COMPILE_PATH/SYSROM_SRC/dev/AL/AL_Build.log");
		}

		my $LOG_FILE_PATH = "$COMPILE_PATH/SYSROM_SRC/dev/AL/AL_Build_Temp.log";

		system("cd dev/AL/ && make -f Makefile_AL_TESI clean all > AL_Build_Temp.log 2>&1 && sed \'/warning:/d\' $LOG_FILE_PATH > AL_Build.log");
		system("cat $COMPILE_PATH/SYSROM_SRC/dev/AL/Encoding.log >> $COMPILE_PATH/SYSROM_SRC/dev/AL/AL_Build.log"); 

	}
	else
	{
		print "Compilation path doesn't contain previous build's source files\n";
	}

	$compEndTime = localtime();
	print "Compilation Done.End Time:",$compEndTime . "\n";
}

sub VALIDATE_ARGUMENTS
{
	my $numArgs = $#ARGV + 1;
	my $retValue = 0;

	if($numArgs != 3)
	{
		print colored ['red'],"USAGE: ./script_name \"Workset to Download\" \"Compilation Path\" \"Product Name\"\n";
		print colored ['red'],"Eg: ./Build_Automation_Impr.pl $ARG1 $ARG2 $ARG3\n";
		print "Note:Compilation Path should contain folder named SYSROM_SRC with all source files in it\n";
		print "TESI-AL components in SYSROM_SRC folder will be replaced by files from latest REL_WS in PVCS\n";

		return 100;
	}
	else 
	{
		if(! -d $_[1])
		{
			#Compilation Path doesn't exists.
			$retValue = 1; 
		}
		else	
		{

			my $SRC_FILES_PATH = "$COMPILE_PATH\/SYSROM_SRC";

			if(! -d $SRC_FILES_PATH)
			{
				#Compilation Path Exists.But,Previous build is not available.
				$retValue = 4;
			}
			
			my $EB2 = $ENV{'EB2'};
			$SRC_FILES_PATH = abs_path($SRC_FILES_PATH);

			#if(($EB2 =~ m/$SRC_FILES_PATH/) || ($EB2 eq ""))
			if(($EB2 ne $SRC_FILES_PATH) || ($EB2 eq ""))
			{				
				print "setenv \$EB2 path: $EB2\n";
				print "Provided compilation path: $SRC_FILES_PATH\n";

				#setenv is not done or it is incorrectly set
				return 5;
			}
		          
		}

		system("/opt/serena/dimensions/10.1/cm/prog/dmcli -con ebx_DIM10_New -user asivasankar -pass Toshiba1 -cmd 'LWS /FILENAME=worksets.txt' > pvcs.log 2>&1");

		open(FILE,"pvcs.log");
		if(grep{/Error:|Session\ Expired/} <FILE>)
		{
			close FILE;

			#system("rm -f pvcs.log");

			return 2;    
		}

		open(FILE,"worksets.txt");
		if (! grep{/$_[0]/} <FILE>)
		{
			$retValue = 3;         
		}
		close FILE;

		system("rm -f worksets.txt");

		#system("rm -f pvcs.log");

		return $retValue;
	}
}

my @XMLfiles = ();
sub VALIDATE_XML
{
  print "Finding XML files for validation..\n";
  find(\&mySub,"$COMPILE_PATH/05_Implement/\SYSROM_SRC/\Resources_Common");

	print "Found XML files.Validating started...\n";

  my $bError = 0;
  my ($result, $file);
  open(FILE,'>XML_Error_Files.txt');
  foreach $file (@XMLfiles)
  {
    $result = system("unset LD_LIBRARY_PATH;/usr/bin/xmllint $file >temp 2>&1");
    if($result != 0)
    {
        $bError = 1;
				print "XML-Error: $file\n";
        print FILE "<font color = \"Red\">", $file,"</font></br>";
    }
  }
  close(FILE);
  if($bError == 0)
  {
     system("rm -f XML_Error_Files.txt");
  }

   system("rm -f temp");

	 print "Validating XML files completed with errorcode(0-Success,1-Error) $bError\n";
}
    
sub mySub()
{
   push @XMLfiles, $File::Find::name if(/\.xml$/i);
}

sub CHECK_COMPILATION_ERRORS
{
	my $EB2 = $ENV{'EB2'};
	my $binError = 0;
	my $libError = 0;

	my $File;
	my $Lib;

	print "EB2 = $EB2\n";

	open (MYFILE, '>errors.txt');
#print MYFILE "Executables:</br>\n";
	foreach $File (keys(%alBinaries))
	{
		unless(-e "$EB2/bin/$File")
		{
			if($binError == 0)
			{
				$binError = 1;
				print MYFILE "<b>Executables:</b></br>\n";
			}
			print MYFILE "<font color = \"Red\">", $alBinaries{$File}, "</font></br>\n";
		} 
	}

	foreach $Lib (keys(%alLibs))
	{
		unless(-e "$EB2/lib/$Lib")
		{
			if($libError == 0)
			{	
				$libError = 1;
				print MYFILE "<b>Libraries:</b></br>\n";
			}
			print MYFILE "<font color = \"Red\">", $alLibs{$Lib}, "</font></br>\n";
		}
	}
	close (MYFILE);

	print"binError = $binError, libError = $libError\n";

	if($binError == 0 && $libError == 0)
	{
		system("rm -f errors.txt");
	}

}

sub SEND_MAIL
{
	system("who am i | cut -d'(' -f2 |cut -d')' -f1>Sender.txt");
        open(FILE_Sender,"Sender.txt");
        my $SENDER_NAME = <FILE_Sender>;
        close (FILE_Sender);
	my $msg = MIME::Lite->new(
			From    => $FROM_ADDRESS,
			To      => $TO_ADDRESS,
			Subject => "$EBX_PRODUCT: TESI-AL Components Build Report..Initiated by $SENDER_NAME",
			Type    => 'multipart/mixed',
			);

	my $mailBody;
	my $xmlError = 0;
	if(-e "$Bin/XML_Error_Files.txt")
	{
		$xmlError = 1;
	}
	
	if(-e "errors.txt") 
	{
		open (MYFILE, 'errors.txt');
		my @fileData = <MYFILE>;
		close (MYFILE);

		system("rm -rf errors.txt");

		       $mailBody = "Hi All,<br><br>
                        Compilation results: <br><br>
                        <table border=\"3\">
                                <tr bgcolor=\"A3FF85\">
                                        <th><i>Main Target</i></th>
                                        <th><i>Sub Target</i></th>
                                        <th><i>Start Time</i></th>
                                        <th><i>End Time</i></th>
                                        <th><i>Compilation Status</i></th>
                                </tr>
                                <tr>
                                        <td>$WORKSET</td>
                                        <td>$SUB_WORKSET</td>
                                        <td>$compStartTime</td>
                                        <td>$compEndTime</td>
                                        <th bgcolor = \"CC0000\"><i>Failed</i></th>
                                </tr>
                        </table>
                        <br>
                        <br>
                        Compilation of the following components failed:
                        @fileData
                        <br>
                        Build log with Validation Results for Encoding Format is attached for your reference.
                        <br>
                        ----------------------------------------------------"

					
					  
	

	}
	else
	{
        $mailBody = "Hi All,<br><br>
			Compilation results: <br><br>
			<table border=\"3\">
				<tr bgcolor=\"A3FF85\">
					<th><i>Main Target</i></th>
                                        <th><i>Sub Target</i></th>
                                        <th><i>Start Time</i></th>
                                        <th><i>End Time</i></th>
                                        <th><i>Compilation Status</i></th>
                                </tr>
				<tr>
					<td>$WORKSET</td>
					<td>$SUB_WORKSET</td>
					<td>$compStartTime</td>
					<td>$compEndTime</td>
					<th><i>Success</i></th>
				</tr>
                        </table>
			<br>
			<br>
			Build log with Validation Results for Encoding Format is attached for your reference.
			<br>
			----------------------------------------------------"

	 	}

	$msg->attach(
			Type     => 'TEXT/HTML',
			Data     => "$mailBody",
		    );

	$msg->attach(
			Type     => 'text/log',
			Path     => "$COMPILE_PATH/SYSROM_SRC/dev/AL/AL_Build.log",
			Filename => 'AL_Build.log',
		    );

	$msg->send;

}

sub CHECK_DEV_DOC_FILES
{
	my $file;
	my @fileData;
	my $bNewDocFile = 0;

	if(-e "$Bin/DEV_DOC.txt")
	{
		open (MYFILE, 'DEV_DOC.txt');
		@fileData = <MYFILE>;
		close (MYFILE);

		system("rm -rf $Bin/DEV_DOC.txt");

		open (MYFILE,'>New_DEV_DOC_Files.txt');

		foreach $file (@fileData)
		{
			my $refFile;
			my $bNewFile = 1;
			foreach $refFile (@DEV_DOC_FILES)
			{
				if($file =~ m/$refFile/)
				{
					$bNewFile = 0;
					last;
				}
			}
			if($bNewFile == 1)
			{
				print "New DEV_DOC file found ",$file;
				print MYFILE "<font color = \"Red\">", $file,"</font></br>";
				$bNewDocFile = 1;
			}	
		}

		close (MYFILE);

		if($bNewDocFile == 1)
		{
			open (MYFILE,"$Bin/New_DEV_DOC_Files.txt");
			my @docFile = <MYFILE>;
			close (MYFILE);

			my $msg = MIME::Lite->new(
					From    => $FROM_ADDRESS,
					To      => $TO_ADDRESS,
					Subject => "$EBX_PRODUCT: New Files with Lifecycle as DEV_DOC found",
					Type    => 'multipart/mixed',
					);

			my $mailBody = "Hi All,</br></br>
				New files checked-in as DEV_DOC are found in $SUB_WORKSET. Please check. XML validation & Compilation continues..</br>
				@docFile</br>
				</br>
				---------------------------------------------------</br>";

			$msg->attach(
					Type     => 'TEXT/HTML',
					Data     => "$mailBody",
				    );

			$msg->send;
		}

		system("rm -rf $Bin/New_DEV_DOC_Files.txt");
	}
}
my $retVal = VALIDATE_ARGUMENTS($ARGV[0],$ARGV[1]);
if($retVal == 0)
{
	my $time = 	localtime();
	print colored ['cyan'],"Local build start time:",$time . "\n";
	
	#Check if any other INTEG workset compilation is underway to prevent folder overwrite
	#my $proc_table = Proc::ProcessTable->new;
	#my $proc;

	#CHECK_RUNNING: foreach $proc (@{$proc_table->table}) 
	#{
	#	my $exists = grep { $proc->{cmndline} =~ /Build_Automation_Impr.pl\ INTEG/ } {$proc_table->fields};
	#	if($exists)
	#	{
	#		if($proc->{pid} != $$) #make sure the process found is not itself
	#		{
	#			print colored ['red'], "Looks like a different INTEG WORKSET compilation is currently underway.\nPlease wait for it to finish!!\n";
	#			exit 0;
	#		}
	#	}
	#}

	#print colored ['cyan'], "No other integration worksets are currently under compilation. Proceeding...\n";

	#DOWNLOAD();

	#DOWNLOAD_SUB();	

	#CHECK_DEV_DOC_FILES();

	#VALIDATE_XML();

	#COPY();   
	
	#THIRD_PARTY_SETUP();
	system("sh Encoding.sh &> SYSROM_SRC/dev/AL/Encoding.log");
	print "after creating log";
	COMPILE();
	
	CHECK_COMPILATION_ERRORS();

	SEND_MAIL();

	$time =  localtime();
	print colored ['cyan'],"Local build end time:",$time . "\n";
}

switch($retVal)
{
	case 1 {print colored ['red'],"Compilation Path Doesn't Exists\n";}
	case 2 {print colored ['red'],"DIM 10 Server Busy..\n";}
	case 3 {print colored ['red'],"Workset not found in DIM10\n";}
	case 4 {print colored ['red'],"Compilation path doesn't contain previous build's source files\n";}
	case 5 {print colored ['red'],"Either setenv is not done or incorrectly set.Please check!!!!!\n";}
}
