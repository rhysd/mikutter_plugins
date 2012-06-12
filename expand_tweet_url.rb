Plugin.create :filter do

    filter_show_filter do |msgs|
        msg.each do |m|
            m[:message].gsub! /https?:\/\/twitter\.com\/([_a-zA-Z0-9]+?)\/status\/(\d+)/ do
                if $1 && $2
                    require 'twitter'
                    begin
                        status = Twitter.status $2.to_i
                        "(refer to: @" + $1 + ": " + status["text"] + " )"
                    rescue
                        "https://twitter.com/" + $1 + "/status/" + $2
                    end
                else
                    "(refer to: 参照先を取得できませんでした )"
                end
            end
        end
    end

end
