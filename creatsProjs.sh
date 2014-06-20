User="ubuntu"
installDir="/home/$User/EclimTest"

#required for Project Creation in Eclim
#assuming c libraries are present in /usr/include
#assuming c++ libraries are present in /usr/include/c++
#assuming ruby interpreter is at /usr/local/bin/ruby

rubyInterpreter="/usr/bin/ruby"
cInclude="/usr/include"
cppInclude="/usr/include/c++"
#give full path of the directory where Eclim projects have to be created, this directory should be modifiable without sudo permissions

supportedLanguages="$installDir/eclipse/supportedLanguages"

#to start eclim as a background process
#$installDir/eclipse/eclimd -b

#uncomment it and comment the above to start eclim in debugging mode
#$installDir/eclipse/eclimd -d &

#uncomment the following 6 lines to wait for some time and let the eclim server start
#line="wait"
#while [ "$line" != "yes" ]
#do
#	echo "Type 'yes' after some time"
#	read line
#done

#wait for the eclim server to start accepting requests
eclimTry=$( $installDir/eclipse/eclim -? commands 2> tmp )
eclimTry=$(<tmp)
echo "starting while"
tries=0 #setting maximum tries 15 else throw error and exit, server usually starts in about 15 sec
while [ "$eclimTry" == "connect: Connection refused" -a $tries -lt 15 ]
do
	sleep 10 #sleep for 10 seconds and try to connect again
	eclimTry=$( $installDir/eclipse/eclim -? commands 2> tmp )
	eclimTry=$(<tmp)
	echo "trying again"
	(( tries++ ))
done

#Eclim server failed to start
if [ $tries -eq 15 ]; then
	echo "Eclim server failed to start.. Exiting"
	exit
fi

#Create the following projects if the server starts successfully
echo "Eclim Server started successfully"
eclimTry=$($installDir/eclipse/eclim -? commands 2> tmp)

#Creating and configuring Eclim projects
mkdir $supportedLanguages
mkdir $supportedLanguages/java
mkdir $supportedLanguages/cpp
mkdir $supportedLanguages/ruby

#creating java projects
echo "creating java"
$installDir/eclipse/eclim -command project_create -f $supportedLanguages/java/ -n java

#creating c++ projects and configuring
echo "creating c/cpp"
$installDir/eclipse/eclim -command project_create -f $supportedLanguages/cpp/ -n cpp
$installDir/eclipse/eclim -command c_project_include -p cpp -a add -l c++ -d $cppInclude
$installDir/eclipse/eclim -command c_project_include -p cpp -a add -l c -d $cInclude

#creating ruby projects
echo "creating ruby"
$installDir/eclipse/eclim -command project_create -f $supportedLanguages/ruby/ -n ruby
$installDir/eclipse/eclim -command ruby_add_interpreter -p $rubyInterpreter
