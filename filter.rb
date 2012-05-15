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
        exclusive_clients = UserConfig[:filter_mute_kind_clients]
        if exclusive_clients
            exclusive_clients = exclusive_clients.split ","
            msgs = msgs.delete_if do |m|
                exclusive_clients.any?{|c| m[:source].to_s.include? c if m[:source] }
            end
        end
        [service,msgs]
    end

    # 単語フィルタ
    filter_update do |service,msgs|
        exclusive_words = UserConfig[:filter_exclusive_words]
        if exclusive_words
            exclusive_words = exclusive_words.split ","
            msgs = msgs.delete_if do |m|
                exclusive_words.any?{|w| m[:message].include? w if m[:message] }
            end
        end
        [service,msgs]
    end

    # ユーザフィルタ
    filter_update do |service,msgs|
        exclusive_users = UserConfig[:filter_mute_users]
        if exclusive_users
            exclusive_users = exclusive_users.split ","
            msgs = msgs.delete_if do |m|
                exclusive_users.any?{|u| m[:user].to_s == u if m[:user]}
            end
        end
        [service,msgs]
    end

    settings "フィルタ" do
        input "クライアント（半角カンマ区切り）", :filter_mute_kind_clients
        input "単語（半角カンマ区切り）", :filter_mute_words
        input "ユーザ（半角カンマ区切り）", :filter_mute_users
    end

end
