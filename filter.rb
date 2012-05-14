#!/usr/bin/env ruby -Ku
# -*- coding: utf-8 -*-

Plugin.create(:filter) do
    filter_show_filter do |msgs|
        mute_words = UserConfig[:filter_mute_kind_client]
        if mute_words
            mute_words = mute_words.split(",")
            msgs = msgs.select{ |m|
                not mute_words.any?{ |word|
                    word.to_s.include?(m[:source]) if m[:source] != nil
                }
            }
        end
        [msgs]
    end

    filter_show_filter do |msgs|
        mute_words = UserConfig[:filter_mute_word]
        if mute_words
            mute_words = mute_words.split(",")
            msgs = msgs.select{ |m|
                not mute_words.any?{ |word|
                    m[:message].include?(word)
                }
            }
        end
        [msgs]
    end

    filter_show_filter do |msgs|
        mute_words = UserConfig[:filter_mute_user]
        if mute_words
            mute_words = mute_words.split(",")
            msgs = msgs.select{ |m|
                not mute_words.any?{ |word|
                    m[:user].to_s == word
                }
            }
        end
        [msgs]
    end

    settings "ミュート" do
        # self.methods.sort.each{|m| puts m }
        input "クライアント", :filter_mute_kind_client
        input "単語", :filter_mute_word
        input "ユーザ", :filter_mute_user
    end

end
