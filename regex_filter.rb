#!/usr/bin/env ruby -Ku
# -*- coding: utf-8 -*-

Plugin.create :filter do

    # ホームTLのみから削除
    # 次のようにするとすべてのタブから除去
    #
    # filter_show_filter do |msgs|
    # ...

    # クライアントフィルタ
    filter_update do |service,msgs|
        exclusive_clients = UserConfig[:regex_filter_mute_clients]
        if exclusive_clients
            begin
                exclusive_clients = exclusive_clients.map{|c| /#{c}/}
                msgs = msgs.delete_if do |m|
                    exclusive_clients.any?{|c| m[:source].to_s =~ c if m[:source] }
                end
            rescue RegexpError
            end
        end
        [service,msgs]
    end

    # 単語フィルタ
    filter_update do |service,msgs|
        exclusive_words = UserConfig[:regex_filter_mute_words]
        if exclusive_words
            begin
                exclusive_words = exclusive_words.map{|w| /#{w}/}
                msgs = msgs.delete_if do |m|
                    exclusive_words.any?{|w| m[:message].to_s =~ w if m[:message] }
                end
            rescue RegexpError
            end
        end
        [service,msgs]
    end

    # ユーザフィルタ
    filter_update do |service,msgs|
        exclusive_users = UserConfig[:regex_filter_mute_users]
        if exclusive_users
            begin
            exclusive_users = exclusive_users.map{|u| /#{u}/}
            msgs = msgs.delete_if do |m|
                exclusive_users.any?{|u| m[:user].to_s =~ u if m[:user] }
            end
            rescue RegexpError
            end
        end
        [service,msgs]
    end

    settings "正規表現フィルタ" do
        multi "本文", :regex_filter_mute_words
        multi "ユーザ名（@不要）", :regex_filter_mute_users
        multi "クライアント", :regex_filter_mute_clients
    end

end
