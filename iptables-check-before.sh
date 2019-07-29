#!/usr/bin/env bash


## Checks for rule prior to issueing 'append' or 'delete' to iptables
iptables_check_before(){
    local _rule_args=("${@:?Parameter_Error: ${FUNCNAME[0]} not provided any arguments}")

    case "${_rule_args[*]}" in
        *'--append'*|*'-A'*)
            local _check_args=($(sed 's@--append@--check@; s@-A@-C@' <<<"${_rule_args[@]}"))
            local _action='append'
        ;;
        *'--delete'*|*'-D'*)
            local _check_args=($(sed 's@--delete@--check@; s@-D@-C@' <<<"${_rule_args[@]}"))
            local _action='delete'
        ;;
        *)
            printf '%s did not understand: %s\n' "${FUNCNAME[0]}" "${@}" >&2
            return 1
        ;;
    esac

    case "${_action,,}" in
        'append')
            iptables "${_check_args[@]}" 2>/dev/null || iptables "${_rule_args[@]}"
        ;;
        'delete')
            iptables "${_check_args[@]}" 2>/dev/null && iptables "${_rule_args[@]}"
        ;;
    esac
}
