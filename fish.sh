function fish_prompt
    set_color cyan
    echo -n (whoami)"@"(hostname)
    set_color yellow
    echo -n " "(prompt_pwd)
    set_color normal
    echo " > "
end
