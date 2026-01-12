{{{ if (loadingMore && @first)}}}
<div class="im-list-loading-separator"></div>
{{{ end }}}

<div component="chat/recent/room" 
     data-roomid="{./roomId}" 
     data-full="1" 
     class="im-list-item d-flex align-items-center px-3 py-2 bg-white {{{ if ./unread }}}unread{{{ end }}}">
    
    <!-- 1. 左侧：头像 (点击跳转个人主页) -->
    <div class="im-list-avatar-box me-3 position-relative flex-shrink-0">
        <!-- 强制取第0个用户（对方），不使用群聊堆叠头像 -->
        <a href="{config.relative_path}/user/{./users.0.userslug}" class="text-decoration-none" style="z-index: 2; position: relative;">
            {buildAvatar(./users.0, "48px", true, "im-list-avatar shadow-sm")}
        </a>
        
        <!-- 未读红点 (头像右上角) -->
        {{{ if ./unread }}}
        <span class="position-absolute top-0 start-100 translate-middle p-1 bg-danger border border-light rounded-circle" style="width: 10px; height: 10px; margin-left: -5px; margin-top: 5px;">
            <span class="visually-hidden">New alerts</span>
        </span>
        {{{ end }}}
    </div>

    <!-- 2. 右侧：聊天触发区 (点击进入聊天) -->
    <!-- 注意：这里用 chat-room-btn 类，NodeBB JS 会绑定点击事件 -->
    <div class="chat-room-btn d-flex flex-column flex-grow-1 overflow-hidden justify-content-center" style="cursor: pointer; height: 60px;">
        
        <!-- 第一行：名字 + 时间 -->
        <div class="d-flex justify-content-between align-items-center mb-1">
            <span component="chat/room/title" class="im-list-name fw-bold text-dark text-truncate" style="font-size: 16px; max-width: 70%;">
                {{{ if ./roomName}}}
                    {./roomName}
                {{{ else }}}
                    {./users.0.displayname}
                {{{ end }}}
            </span>
            <!-- 时间 -->
            <small class="text-muted timeago" style="font-size: 11px;" title="{./lastMessage.timestampISO}"></small>
        </div>

        <!-- 第二行：消息预览 -->
        <div class="im-list-teaser text-muted text-truncate" style="font-size: 13px; opacity: 0.8;">
             <!-- 这里直接引用 teaser 内容，去除原来复杂的 import 以保持样式纯净 -->
             {{{ if ./teaser.content }}}
                {./teaser.content}
             {{{ else }}}
                <span class="fst-italic">无消息</span>
             {{{ end }}}
        </div>
    </div>

    <!-- 移除了原有的 mark-read 按钮，微信风格通常是点进去自动消红点 -->
</div>
