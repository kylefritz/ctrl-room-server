#ctrl-room server



##delete data

    $ heroku console
    >> Ohm.connect :url => ENV['REDISTOGO_URL']
    >> User.all.all
     # shows all users in an array
    >> u=User.find(:email=>'someuser@example.com').all[0]
    >> u.delete 

##in javascript

    new Date(user.projects[0].events[0].date)
