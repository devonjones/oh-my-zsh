
alias saws='aws-env -e staging > ~/.k.aws/$$.currenv ; source ~/.k.aws/$$.currenv ; rm ~/.k.aws/$$.currenv'
alias paws='aws-env -e production > ~/.k.aws/$$.currenv ; source ~/.k.aws/$$.currenv ; rm ~/.k.aws/$$.currenv'
alias uaws='aws-env -e utility > ~/.k.aws/$$.currenv ; source ~/.k.aws/$$.currenv ; rm ~/.k.aws/$$.currenv'
alias uataws='aws-env -e uat > ~/.k.aws/$$.currenv ; source ~/.k.aws/$$.currenv ; rm ~/.k.aws/$$.currenv'
alias analaws='aws-env -e analytics > ~/.k.aws/$$.currenv ; source ~/.k.aws/$$.currenv ; rm ~/.k.aws/$$.currenv'
