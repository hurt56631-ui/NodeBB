<li component="chat/message" class="chat-message mx-2 mb-2 d-flex {{{ if messages.deleted }}}deleted{{{ end }}} {{{ if messages.pinned }}}pinned{{{ end }}} {{{ if messages.self }}}flex-row-reverse self{{{ else }}}other{{{ end }}}" 
    data-mid="{messages.messageId}" 
    data-uid="{messages.fromuid}" 
    data-index="{messages.index}" 
    data-self="{messages.self}" 
    data-break="{messages.newSet}" 
    data-timestamp="{messages.timestamp}" 
    data-username="{messages.fromUser.username}" 
    data-displayname="{messages.fromUser.displayname}">

    <!-- 1. 头像列 -->
    <div class="im-avatar-col {{{ if messages.self }}}ms-2{{{ else }}}me-2{{{ end }}}">
        {{{ if messages.newSet }}}
        <a href="{config.relative_path}/user/{messages.fromUser.userslug}" class="text-decoration-none">
            {buildAvatar(messages.fromUser, "42px", true, "im-chat-avatar")}
        </a>
        {{{ else }}}
        <!-- 连续发言时的占位符，保持对齐 -->
        <div class="im-avatar-placeholder" style="width: 42px;"></div>
        {{{ end }}}
    </div>

    <!-- 2. 消息内容列 (最大宽度80%) -->
    <div class="im-message-content d-flex flex-column {{{ if messages.self }}}align-items-end{{{ else }}}align-items-start{{{ end }}}" style="max-width: 80%; position: relative;">

        <!-- (仅群聊/对方) 显示名字 -->
        {{{ if !messages.self }}}
            {{{ if messages.newSet }}}
            <span class="im-chat-name text-muted ms-1 mb-1" style="font-size: 12px;">{messages.fromUser.displayname}</span>
            {{{ end }}}
        {{{ end }}}

        <!-- 3. 气泡本体 -->
        <div class="im-bubble shadow-sm position-relative">
            
            <!-- 引用 (Parent) 功能保留 -->
            {{{ if messages.parent }}}
            <div class="im-quote-wrapper mb-1 p-2 rounded opacity-75" style="background: rgba(0,0,0,0.05); font-size: 0.9em;">
                <!-- IMPORT partials/chats/parent.tpl -->
            </div>
            {{{ end }}}

            <!-- 消息正文 -->
            <div component="chat/message/body" class="message-body text-break" style="min-height: auto;">
                {messages.content}
            </div>
            
            <!-- 消息编辑标记 -->
            <div component="chat/message/edited" class="text-muted text-end fst-italic {{{ if !messages.edited }}}hidden{{{ end }}}" style="font-size: 10px; opacity: 0.6;">
                <i class="fa fa-edit"></i> [[global:edited]]
            </div>

            <!-- 表情反应 (Reactions) 保留 -->
            <div class="im-reactions mt-1">
                <!-- IMPORT partials/chats/reactions.tpl -->
            </div>
        </div>

        <!-- 4. 底部元数据 (时间) - 移到气泡外面或紧贴底部 -->
        <div class="im-meta d-flex align-items-center mt-1 px-1" style="opacity: 0.6; font-size: 11px;">
            <span class="chat-timestamp text-muted timeago" title="{messages.timestampISO}"></span>
        </div>

    </div>

    <!-- 5. 操作按钮组 (悬浮/点击显示) - 功能完全保留 -->
    <div component="chat/message/controls" class="im-controls align-self-center px-2">
        <div class="btn-group dropup">
            <!-- 快速回复按钮 -->
            <button class="btn btn-sm btn-link text-decoration-none text-muted p-0 me-2" data-action="reply" title="[[topic:reply]]">
                <i class="fa fa-reply"></i>
            </button>

            <!-- 更多菜单 (三点) -->
            <button class="btn btn-sm btn-link dropdown-toggle text-decoration-none text-muted p-0" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                <i class="fa fa-ellipsis-v"></i>
            </button>

            <!-- 原生菜单列表 (原封不动保留) -->
            <ul class="dropdown-menu p-1 text-sm list-unstyled shadow border-0" role="menu">
                <!-- IMPORT partials/chats/add-reaction.tpl -->
                
                {{{ if (isAdminOrGlobalMod || (!config.disableChatMessageEditing && messages.self)) }}}
                <li><a href="#" class="dropdown-item rounded-1" data-action="edit"><i class="fa fa-fw fa-pencil text-muted"></i> [[topic:edit]]</a></li>
                <li><a href="#" class="dropdown-item rounded-1" data-action="delete"><i class="fa fa-fw fa-trash text-muted"></i> [[topic:delete]]</a></li>
                <li><a href="#" class="dropdown-item rounded-1" data-action="restore"><i class="fa fa-fw fa-repeat text-muted"></i> [[topic:restore]]</a></li>
                {{{ end }}}

                {{{ if (isAdminOrGlobalMod || isOwner )}}}
                <li><a href="#" class="dropdown-item rounded-1" data-action="pin"><i class="fa fa-fw fa-thumbtack text-muted"></i> [[modules:chat.pin-message]]</a></li>
                <li><a href="#" class="dropdown-item rounded-1" data-action="unpin"><i class="fa fa-fw fa-thumbtack fa-rotate-90 text-muted"></i> [[modules:chat.unpin-message]]</a></li>
                <li class="dropdown-divider"></li>
                {{{ end }}}

                {{{ if isAdminOrGlobalMod }}}
                <li>
                    <a href="#" class="dropdown-item rounded-1 chat-ip-button">
                        <span class="show"><i class="fa fa-fw fa-info-circle text-muted"></i> [[modules:chat.show-ip]]</span>
                        <span class="copy hidden"><i class="fa fa-fw fa-copy text-muted"></i> <span class="copy-ip-text"></span></span>
                    </a>
                </li>
                {{{ end }}}

                <li><a href="#" class="dropdown-item rounded-1" data-action="copy-text" data-mid="{messages.mid}"><i class="fa fa-fw fa-copy text-muted"></i> [[modules:chat.copy-text]]</a></li>
                <li><a href="#" class="dropdown-item rounded-1" data-action="copy-link" data-mid="{messages.mid}"><i class="fa fa-fw fa-link text-muted"></i> [[modules:chat.copy-link]]</a></li>
            </ul>
        </div>
    </div>
</li>
