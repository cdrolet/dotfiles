# ssh/bastion
alias ssh-tcs-redis-test='ssh cdrolet@tcs_redis_test -F ~/.ssh/config-test'
alias ssh-tcs-redis-prod='ssh cdrolet@tcs_redis_prod -F ~/.ssh/config-prod'
alias ssh-ch-redis-test='ssh cdrolet@ch_redis_test -F ~/.ssh/config-test'
alias ssh-ch-redis-prod='ssh cdrolet@ch_redis_prod -F ~/.ssh/config-prod'
alias ssh-tcs-db-test='ssh cdrolet@tcs_postgres_test -F ~/.ssh/config-test'
alias ssh-tcs-db-prod='ssh cdrolet@tcs_postgres_prod -F ~/.ssh/config-prod'
alias ssh-ch-db-test='ssh cdrolet@ch_rds_test -F ~/.ssh/config-test'
alias ssh-ch-db-prod='ssh cdrolet@ch_rds_prod -F ~/.ssh/config-prod'
alias ssh-lds='ssh cdrolet@lds_prod -F ~/.ssh/config-prod'

alias chdbtest='ssh -vv -N -L 3306:cs-ch-test.ck0qdwknsfda.us-west-2.rds.amazonaws.com:3306 cdrolet@bastion.us-west-2.test.lodgingshared.expedia.com'
alias chdbprod='ssh -vv -N -L 3306:cs-ch-prod-db.chqdvg3bcpcy.us-west-2.rds.amazonaws.com:3306 cdrolet@bastion.us-west-2.prod.lodgingshared.expedia.com'
alias chcacheprod='ssh -vv -N -L 6379:cs-ch-cache.qbusfq.clustercfg.usw2.cache.amazonaws.com:6379 cdrolet@bastion.us-west-2.prod.lodgingshared.expedia.com'
alias cgsdbprod='ssh -vv -N -L 3306:cgs-content-db.prod.expedia.com:3306 cdrolet@bastion.us-west-2.prod.expedia.com'

alias bastion-test-east='ssh bastion.us-east-1.test.lodgingshared.expedia.com'
alias bastion-test-west='ssh bastion.us-west-2.test.lodgingshared.expedia.com'
alias bastion-prod-east='ssh bastion.us-east-1.prod.lodgingshared.expedia.com'
alias bastion-prod-west='ssh bastion.us-west-2.prod.lodgingshared.expedia.com'

