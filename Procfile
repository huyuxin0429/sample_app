web: [[ "$ANYCABLE_DEPLOYMENT" == "true" ]] && bundle exec anycable --server-command="anycable-go" || bundle exec puma -C config/puma.rb

clock: bundle exec clockwork lib/clock.rb