:- module(styles, [ansi_style/2]).

ansi_style(special_item, [fg(cyan)]).
ansi_style(title, [bold, fg(green)]).
ansi_style(error, [bold, fg(red)]).
ansi_style(specify, [bold, fg(magenta)]).
ansi_style(verify, [bold, fg(blue)]).
ansi_style(information, [fg(yellow)]).
ansi_style(_, []).