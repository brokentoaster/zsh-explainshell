# ZSH plugin to lookup current command line on explainshell.com
#
# requires lynx for getting and formatting the explanation from explainshell.com
# requires tmux if using the window command 

typeset -gA Plugins

# set the browser command here eg firefox, chrome or xdg-open
Plugins[explainshell_browser_cmd]="xdg-open"

# set your favourite man tool here.
Plugins[explainshell_man_cmd]="man"


# Convert the given command line to a URL for explainshell.com.
#
# Globals:
#   URL is stored in Plugins[explainshell_url].
#   converted query is stored Plugins[explainshell_query].
# Arguments:
#   $@ is Command line to convert to URL.
cmd_to_URL(){
    # replace spaces with '+'
    Plugins[explainshell_query]=${@:gs/ /\+}

    # add base URL to query to get final URL 
    Plugins[explainshell_url]="https://explainshell.com/explain?cmd=${Plugins[explainshell_query]}"
}


# Use lynx to get the explanation.
#
# Globals:
#   URL is stored in Plugins[explainshell_url].
# Outputs:
#   prints reformatted webpage sections to stdout
get_explainshell_as_text(){
    # get the answer using lynx and remove the header
    lynx $Plugins[explainshell_url] -dump -nolist -width=120 \
            | sed '1,8d'
}


# Print the explanation below the command line.
#
# Globals:
#   $BUFFER contains the current command line.
#   URL is stored in Plugins[explainshell_url].
# Outputs:
#   prints to stdout
explainshell_cmd() {
    cmd_to_URL $BUFFER
    printf "\nGetting '${Plugins[explainshell_url]}'...\n" 
    get_explainshell_as_text 
    printf  "\n>> $BUFFER <<\n"
    printf "\nPress Enter to execute or <CTRL-C> to abort"
}


# Pop up the explanation in a tmux split and use less to explore.
#
# Globals:
#   $BUFFER contains the current command line.
# Outputs:
#   prints to stdout in a tmux split
explainshell_cmd_window() {
    temp_file=$(mktemp)

    cmd_to_URL $BUFFER
    get_explainshell_as_text > $temp_file
    tmux splitw "cat $temp_file | less"
    #dialog --textbox $temp_file 0 0 
    
    [ -f $temp_file ] && rm $temp_file
}

# Open the explanation in system web browser.
# Globals:
#   $BUFFER contains the current command line.
explainshell_cmd_browser(){
    cmd_to_URL $BUFFER
    $Plugins[explainshell_browser_cmd] "${Plugins[explainshell_url]}"
}

# Get the man page for the first item on the command line 
# Globals:
#   $BUFFER contains the current command line.
explainshell_call_man(){
    $Plugins[explainshell_man_cmd] ${${(zA)BUFFER}[1]}
}


zle -N explainshell_cmd
zle -N explainshell_cmd_window
zle -N explainshell_cmd_browser
zle -N explainshell_call_man


bindkey '^E^E'  explainshell_cmd
bindkey '^E^W'  explainshell_cmd_window
bindkey '^E^M'  explainshell_call_man
bindkey '^E^F'  explainshell_cmd_browser 
