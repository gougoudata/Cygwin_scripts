path=$HOME/sh

#   Preparing:
#   Get infomation of ssh servers from conn/info
declare -a names
declare -a sshs
declare -a pws
i=0
j=0
while read line
do
    k=$((k+1))
    if [ $j == 0 ]
    then
        names[i]=$line
    elif [ $j == 1 ]
    then
        sshs[i]=$line
    elif [ $j == 2 ]
    then
        pws[i]=$line
        i=$((i+1))
    fi
    j=$((j+1))
    if [ $j == 4 ]
    then
        j=0
    fi
done < $path/conn/info;

#   List all server info stored in conn/info
function connList(){
    for (( a = 0 ; a < $i ; a++ ))
    do
        echo ""
        echo "site $a:"
        echo "  name: ${names[a]}"
        echo "  ssh : ${sshs[a]}"
        echo "  pw  : ${pws[a]}"
    done
}

#   Do SSH connecting.
function connSsh(){
    flag=0
    for (( a = 0 ; a < $i ; a++ ))
    do
        if [ $1 == ${names[a]} ]
        then
            echo "pw: ${pws[a]}"
            ssh ${sshs[a]}
            flag=1
        fi
    done
    if [ $flag == 0 ]
    then
        echo "This server is not existed!"
    fi
}

#   To edit the list of servers.
#   Custom command could replace this.
function connEdit(){
    npp $(cygpath -w $path/conn/info)
}

#   Help information.
function connHelp(){
    echo ""
    echo "-l       :   List all server info stored in /info"
    echo "-e       :   To edit the list of servers."
    echo "-s [name]:   Do SSH connecting."
    echo "-h       :   Show this information."
}

#   Commands:

flag=0
if [ $# == 1 ]
then
    if [ $1 == "-h" ]
    then
        connHelp
        flag=1
    elif [ $1 == "-l" ]
    then
        connList
        flag=1
    elif [ $1 == "-e" ]
    then
        connEdit
        flag=1
    fi
fi
if [ $# == 2 ]
then
    if [ $1 == "-s" ]
    then
        connSsh $2
        flag=1
    fi
fi
if [ $flag == 0 ]
then
    echo "Enter \"conn -h\" for helping."
fi