//
//  XHHomeNews.swift
//  Headline
//
//  Created by Klaus on 2018/3/13.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit

class XHHomeNews: NSObject {
    
    var abstract: String!
    
    var title: String!
    
    var media_name: String!
    
    var publish_time: TimeInterval!
    
    var filter_words: [String]?
    
    var read_count: Int!
    
    var article_url: String?
    
// "{message:success,data:
//    [{ content:{\\abstract\\:\\十三届全国人大一次会议举行第四次全体会议听取关于监察法草案的说明、关于国务院机构改革方案的说明3月13日，十三届全国人大一次会议在北京人民大会堂举行第四次全体会议。\\,\\log_pb\\:{\\impr_id\\:\\2018031320495401001501702069911C\\},\\media_info\\:{\\avatar_url\\:\\http://p2.pstatp.com/large/3658/7378365093\\,\\follow\\:false,\\is_star_user\\:false,\\media_id\\:4377795668,\\name\\:\\新华网\\,\\recommend_reason\\:\\\\,\\recommend_type\\:0,\\user_id\\:4377795668,\\user_verified\\:true,\\verified_content\\:\\\\},\\media_name\\:\\新华网\\,\\middle_image\\:{\\height\\:506,\\uri\\:\\list/65c6001324e7df7d48ee\\,\\url\\:\\http://p3.pstatp.com/list/300x196/65c6001324e7df7d48ee.webp\\,\\url_list\\:[{\\url\\:\\http://p3.pstatp.com/list/300x196/65c6001324e7df7d48ee.webp\\},{\\url\\:\\http://pb9.pstatp.com/list/300x196/65c6001324e7df7d48ee.webp\\},{\\url\\:\\http://pb1.pstatp.com/list/300x196/65c6001324e7df7d48ee.webp\\}],\\width\\:900},\\need_client_impr_recycle\\:1,\\preload_web\\:1,\\publish_time\\:1520920987,\\read_count\\:1521128,\\repin_count\\:13314,\\rid\\:\\2018031320495401001501702069911C\\,\\share_count\\:4955,\\share_info\\:{\\cover_image\\:null,\\description\\:null,\\share_url\\:\\http://m.toutiao.com/group/6532306175239651848/?iid=17769976909\\\\u0026app=news_article\\,\\title\\:\\十三届全国人大一次会议举行第四次全体会议\\},\\share_type\\:2,\\share_url\\:\\http://m.toutiao.com/group/6532306175239651848/?iid=17769976909\\\\u0026app=news_article\\,\\show_dislike\\:false,\\show_portrait\\:false,\\show_portrait_article\\:false,\\source\\:\\新华网\\,\\source_icon_style\\:1,\\source_open_url\\:\\sslocal://profile?uid=4377795668\\,\\stick_label\\:\\置顶\\,\\stick_style\\:1,\\tag\\:\\news_politics\\,\\tag_id\\:6532306175239651848,\\tip\\:0,\\title\\:\\十三届全国人大一次会议举行第四次全体会议\\,\\ugc_recommend\\:{\\activity\\:\\\\,\\reason\\:\\新华网官方头条号\\},\\url\\:\\http://m.xinhuanet.com/politics/2018-03/13/c_1122530770.htm\\,\\user_info\\:{\\avatar_url\\:\\http://p3.pstatp.com/thumb/3658/7378365093\\,\\description\\:\\传播中国，报道世界；权威声音，亲切表达。\\,\\follow\\:false,\\follower_count\\:0,\\name\\:\\新华网\\,\\user_auth_info\\:\\{\\\\\\auth_type\\\\\\: \\\\\\0\\\\\\, \\\\\\auth_info\\\\\\: \\\\\\新华网官方头条号\\\\\\}\\,\\user_id\\:4377795668,\\user_verified\\:true,\\verified_content\\:\\新华网官方头条号\\},\\user_repin\\:0,\\user_verified\\:1,\\verified_content\\:\\新华网官方头条号\\,\\video_style\\:0},code:}],
    
//    {"action_extra":"{\"channel_id\": 3431225546}","action_list":[{"action":1,"desc":"","extra":{}},{"action":3,"desc":"","extra":{}},{"action":7,"desc":"","extra":{}},{"action":9,"desc":"","extra":{}}],"aggr_type":1,"allow_download":false,"article_sub_type":0,"article_type":0,"article_url":"http://toutiao.com/group/6532386916984160781/","ban_comment":0,"ban_danmaku":false,"behot_time":1520947314,"bury_count":0,"cell_flag":262155,"cell_layout_style":1,"cell_type":0,"comment_count":0,"content_decoration":"","cursor":1520947314999,"danmaku_count":0,"digg_count":0,"display_url":"http://toutiao.com/group/6532386916984160781/","filter_words":[{"id":"8:0","is_selected":false,"name":"看过了"},{"id":"9:1","is_selected":false,"name":"内容太水"},{"id":"5:1767822986","is_selected":false,"name":"拉黑作者:设攻守"}],"forward_info":{"forward_count":0},"group_flags":32832,"group_id":6532386916984160781,"has_m3u8_video":false,"has_mp4_video":0,"has_video":true,"hot":0,"ignore_web_transform":1,"is_subject":false,"item_id":6532386916984160781,"item_version":0,"keywords":"车位","large_image_list":[{"height":326,"uri":"video1609/6dd2000b910b3290cf03","url":"http://p3.pstatp.com/video1609/6dd2000b910b3290cf03","url_list":[{"url":"http://p3.pstatp.com/video1609/6dd2000b910b3290cf03"},{"url":"http://pb9.pstatp.com/video1609/6dd2000b910b3290cf03"},{"url":"http://pb1.pstatp.com/video1609/6dd2000b910b3290cf03"}],"width":580}],"level":0,"log_pb":{"impr_id":"2018031321215401001205821285187A"},"media_info":{"avatar_url":"http://p3.pstatp.com/large/3ecf00046c6fbc835eb2","follow":false,"is_star_user":false,"media_id":1580966555046925,"name":"设攻守","recommend_reason":"","recommend_type":0,"user_id":71894190246,"user_verified":false,"verified_content":""},"media_name":"设攻守","middle_image":{"height":360,"uri":"list/6dd2000b910b3290cf03","url":"http://p3.pstatp.com/list/300x196/6dd2000b910b3290cf03.webp","url_list":[{"url":"http://p3.pstatp.com/list/300x196/6dd2000b910b3290cf03.webp"},{"url":"http://pb9.pstatp.com/list/300x196/6dd2000b910b3290cf03.webp"},{"url":"http://pb1.pstatp.com/list/300x196/6dd2000b910b3290cf03.webp"}],"width":640},"need_client_impr_recycle":1,"publish_time":1520939850,"read_count":11,"rid":"2018031321215401001205821285187A","share_count":0,"share_info":{"cover_image":null,"description":null,"share_url":"http://m.toutiaoimg.com/a6532386916984160781/?iid=17769976909\u0026app=news_article","title":"对联写得好，不怕车位不好找！妙哉！"},"share_type":2,"share_url":"http://m.toutiaoimg.com/a6532386916984160781/?iid=17769976909\u0026app=news_article","show_dislike":true,"show_portrait":false,"show_portrait_article":false,"source":"设攻守","source_icon_style":6,"source_open_url":"sslocal://profile?refer=video\u0026uid=71894190246","tag":"news","tag_id":6532386916984160781,"tip":0,"title":"对联写得好，不怕车位不好找！妙哉！","ugc_recommend":{"activity":"","reason":""},"url":"http://toutiao.com/group/6532386916984160781/","user_info":{"avatar_url":"http://p3.pstatp.com/thumb/3ecf00046c6fbc835eb2","description":"给你们介绍一种凤头鹀","follow":false,"follower_count":0,"name":"设攻守","user_id":71894190246,"user_verified":false},"user_repin":0,"user_verified":0,"verified_content":"","video_detail_info":{"detail_video_large_image":{"height":326,"uri":"video1609/6dd2000b910b3290cf03","url":"http://p3.pstatp.com/video1609/6dd2000b910b3290cf03","url_list":[{"url":"http://p3.pstatp.com/video1609/6dd2000b910b3290cf03"},{"url":"http://pb9.pstatp.com/video1609/6dd2000b910b3290cf03"},{"url":"http://pb1.pstatp.com/video1609/6dd2000b910b3290cf03"}],"width":580},"direct_play":1,"group_flags":32832,"show_pgc_subscribe":1,"video_id":"4804c0ec3c784df79d3344b6ad2a0058","video_preloading_flag":1,"video_type":0,"video_watch_count":417,"video_watching_count":0},"video_duration":59,"video_id":"4804c0ec3c784df79d3344b6ad2a0058","video_play_info":"{\"status\":10,\"message\":\"success\",\"video_duration\":59.03,\"validate\":\"\",\"enable_ssl\":false,\"poster_url\":\"http://p3.pstatp.com/origin/6dd400093683033beb28\",\"auto_definition\":\"360p\",\"original_play_url\":{\"backup_url\":\"http://voffline.byted.org/download/m/5525d000021190205a757/\",\"main_url\":\"http://voffline.byted.org/download/m/5525d000021190205a757/\"},\"video_list\":{\"video_1\":{\"definition\":\"360p\",\"vtype\":\"mp4\",\"vwidth\":640,\"vheight\":360,\"bitrate\":286267,\"logo_type\":\"xigua\",\"codec_type\":\"h264\",\"size\":2621827,\"main_url\":\"aHR0cDovL3YzLXR0Lml4aWd1YS5jb20vZmRlOTlkYzg3YjFkMGM0ZjdhY2ZhMTYxOWQxMGRjNjEvNWFhN2QwNzMvdmlkZW8vbS8yMjA4M2EzOTEyY2ZlZjM0NzdmOWIwMGM1MGNkNmI2MjJiZDExNTUxM2YyMDAwMDViZjNiNjJjOWMyNS8=\",\"backup_url_1\":\"aHR0cDovL3YxLXR0Lml4aWd1YXZpZGVvLmNvbS83MjdiYjZhYzUzNGVhMTk3ZGVmMjhmNTEzNzY4ZDk1YS81YWE3ZDA3My92aWRlby9tLzIyMDgzYTM5MTJjZmVmMzQ3N2Y5YjAwYzUwY2Q2YjYyMmJkMTE1NTEzZjIwMDAwNWJmM2I2MmM5YzI1Lw==\",\"user_video_proxy\":1,\"socket_buffer\":6440940,\"preload_size\":327680,\"preload_interval\":60,\"preload_min_step\":5,\"preload_max_step\":10,\"encryption_key\":\"\",\"player_access_key\":\"\"},\"video_2\":{\"definition\":\"480p\",\"vtype\":\"mp4\",\"vwidth\":854,\"vheight\":480,\"bitrate\":451657,\"logo_type\":\"xigua\",\"codec_type\":\"h264\",\"size\":3842312,\"main_url\":\"aHR0cDovL3YzLXR0Lml4aWd1YS5jb20vNDIwMTgxNDg3NTNmYmE5YTgzZWIzYWM4ZTY3ZTExMDkvNWFhN2QwNzMvdmlkZW8vbS8yMjA0ZDU4NWI5NmVkYTc0ZTkzOWY3Nzg3ZDk4M2FlMDVmNjExNTU4NDljMDAwMDI5NzNiNmIzZmEzNC8=\",\"backup_url_1\":\"aHR0cDovL3YxLXR0Lml4aWd1YXZpZGVvLmNvbS9hN2MwZTQwNjVmYTEyZmQ1ZmQzYWJhMjM0MTg4NTVhNS81YWE3ZDA3My92aWRlby9tLzIyMDRkNTg1Yjk2ZWRhNzRlOTM5Zjc3ODdkOTgzYWUwNWY2MTE1NTg0OWMwMDAwMjk3M2I2YjNmYTM0Lw==\",\"user_video_proxy\":1,\"socket_buffer\":10162260,\"preload_size\":327680,\"preload_interval\":60,\"preload_min_step\":5,\"preload_max_step\":10,\"encryption_key\":\"\",\"player_access_key\":\"\"},\"video_3\":{\"definition\":\"720p\",\"vtype\":\"mp4\",\"vwidth\":1280,\"vheight\":720,\"bitrate\":1010053,\"logo_type\":\"xigua\",\"codec_type\":\"h264\",\"size\":7960733,\"main_url\":\"aHR0cDovL3YzLXR0Lml4aWd1YS5jb20vNjI5OGJmZDRlMWRlNDZmYjc2MTBlODQ1OWZjNDNhMTEvNWFhN2QwNzMvdmlkZW8vbS8yMjAxMGEwOTY4NWQ4NTM0N2VjYmZlZDY2NmUyNDU3MWQ1NTExNTU2MTAzMDAwMDNhMGNjYTc5ODJmYi8=\",\"backup_url_1\":\"aHR0cDovL3YxLXR0Lml4aWd1YXZpZGVvLmNvbS9lNTg0ZDA1NTBlYjBmODljYTljOWI0MzEyNjNjOWFiYS81YWE3ZDA3My92aWRlby9tLzIyMDEwYTA5Njg1ZDg1MzQ3ZWNiZmVkNjY2ZTI0NTcxZDU1MTE1NTYxMDMwMDAwM2EwY2NhNzk4MmZiLw==\",\"user_video_proxy\":1,\"socket_buffer\":22726080,\"preload_size\":327680,\"preload_interval\":60,\"preload_min_step\":5,\"preload_max_step\":10,\"encryption_key\":\"\",\"player_access_key\":\"\"}},\"dns_info\":{}}","video_style":8}
}
