# Pipe current command line through explain shell
#
# requires lynx for getting and formatting the explanation from explainshell.com
# requires tmux if using the window command 

# TODO: [ ] Remove all the global variables

typeset -gA Plugins

# set the browser command here eg firefox, chrome or xdg-open
Plugins[explainshell_browser]="xdg-open"

# set you man tool here. Normally 'man' but I use 
Plugins[explainshell_man]="nice_man"


#convert the current command line to a URL for explainshell.com
cmd_to_URL(){
    # current line is normally in BUFFER
    # replace spaces with '+'
    Plugins[explainshell_QUERY]=${BUFFER:gs/ /\+}

    # add base URL
    Plugins[explainshell_url]="https://explainshell.com/explain?cmd=${Plugins[explainshell_QUERY]}"
}


# use curl to get the explaination, then pandoc to convert to markdown
get_explainshell_as_text(){
    # get the answer using lynx and remove the header
    lynx $Plugins[explainshell_url] -dump -nolist -width=120 \
            | sed '1,8d'
}


# Print the explanation on the command line 
explainshell_cmd() {
    cmd_to_URL

    # show query on next line  
    printf "\nGetting '${Plugins[explainshell_url]}'...\n" 
    get_explainshell_as_text 
    printf  "\n>> $BUFFER <<\n"
    printf "\nPress Enter to execute or <CTRL-C> to abort"
}


# pop up the explanation in a split and use less to explore
explainshell_cmd_window() {
    cmd_to_URL
    temp_file=$(mktemp)
    get_explainshell_as_text > $temp_file
    tmux splitw "cat $temp_file | less"
    [ -f $temp_file ] && rm $temp_file
}

# open the explanation in system web browser 
explainshell_cmd_browser(){
    cmd_to_URL
    $Plugins[explainshell_browser] "${Plugins[explainshell_url]}"
}

# get the man page for the first item on the command line 
explainshell_call_man(){
    $Plugins[explainshell_man] ${${(zA)BUFFER}[1]}
}


zle -N explainshell_cmd
zle -N explainshell_cmd_window
zle -N explainshell_cmd_browser
zle -N explainshell_call_man


bindkey '^E^E'  explainshell_cmd
bindkey '^E^W'  explainshell_cmd_window
bindkey '^E^M'  explainshell_call_man
bindkey '^E^F'  explainshell_cmd_browser 
