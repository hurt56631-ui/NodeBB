<!-- BEGIN messages -->
<li
  component="chat/message"
  class="chat-message mx-2 pe-2 {{{ if messages.newSet }}}border-top pt-3{{{ end }}} {{{ if messages.self }}}self{{{ else }}}other{{{ end }}}"
  data-mid="{messages.messageId}"
  data-uid="{messages.fromUser.uid}"
  data-index="{messages.index}"
  data-self="{messages.self}"
  data-timestamp="{messages.timestamp}"
>
  <div class="message-container">
    <div class="avatar-container">
      <a href="{config.relative_path}/user/{messages.fromUser.userslug}">
        {buildAvatar(messages.fromUser, "48px", true, "not-responsive rounded-circle")}
        <!-- 在线状态 -->
        <div class="online-status {{{ if messages.fromUser.status 'online' }}}online{{{ end }}}"></div>
        <!-- 国旗 (如果 countryCode 存在) -->
        {{{ if messages.fromUser.countryCode }}}
        <div class="country-flag" style="background-image: url('/path/to/flags/{messages.fromUser.countryCode}.png');"></div>
        {{{ end }}}
      </a>
    </div>

    <div class="message-content-wrapper">
      <div class="message-header {{{ if messages.self }}}hidden{{{ end }}}">
        <span class="chat-user fw-semibold"><a href="{config.relative_path}/user/{messages.fromUser.userslug}" class="text-decoration-none">{messages.fromUser.displayname}</a></span>
      </div>
      <div component="chat/message/body" class="message-body">
        {messages.content}
      </div>
    </div>

    <div component="chat/message/controls" class="message-controls">
        <div class="btn-group">
            <button class="btn btn-sm btn-link dropdown-toggle" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                <i class="fa fa-ellipsis-h"></i>
            </button>
            <ul class="dropdown-menu dropdown-menu-end p-1 text-sm list-unstyled" role="menu">
                <li><a href="#" class="dropdown-item rounded-1" data-action="reply" role="menuitem"><i class="fa fa-fw fa-reply text-muted"></i> 回复</a></li>
                <li><a href="#" class="dropdown-item rounded-1" data-action="copy-text" data-mid="{messages.mid}" role="menuitem"><i class="fa fa-fw fa-copy text-muted"></i> 复制</a></li>
                {{{ if (isAdminOrGlobalMod || (!config.disableChatMessageEditing && messages.self)) }}}
                <li><a href="#" class="dropdown-item rounded-1" data-action="edit" role="menuitem"><i class="fa fa-fw fa-pencil text-muted"></i> 编辑</a></li>
                <li><a href="#" class="dropdown-item rounded-1" data-action="delete" role="menuitem"><i class="fa fa-fw fa-trash text-muted"></i> 删除</a></li>
                {{{ end }}}
            </ul>
        </div>
    </div>
  </div>
</li>
<!-- END messages -->

<!-- 将所有CSS样式直接内联到模板中 -->
<style>
  /* 基础消息样式 */
  .chat-message {
    display: flex;
    margin-bottom: 15px;
    padding-left: 0 !important;
    list-style-type: none;
  }
  .chat-message .message-container {
    display: flex;
    max-width: 80%;
    align-items: flex-start; /* 头像和消息顶部对齐 */
  }

  /* 他人消息 (左侧) */
  .chat-message.other {
    justify-content: flex-start;
  }
  .chat-message.other .message-container {
    flex-direction: row;
  }
  .chat-message.other .message-body {
    background-color: #ffffff;
    color: #333;
    border-radius: 4px 18px 18px 18px;
    border: 1px solid #e5e5e5;
  }
  .chat-message.other .message-header {
    text-align: left;
    margin-left: 10px;
    margin-bottom: 4px;
    font-size: 0.8rem;
    color: #888;
  }

  /* 自己消息 (右侧) */
  .chat-message.self {
    justify-content: flex-end;
  }
  .chat-message.self .message-container {
    flex-direction: row-reverse;
  }
  .chat-message.self .message-body {
    background-color: #a9e87a; /* 微信绿色 */
    color: #000;
    border-radius: 18px 4px 18px 18px;
  }

  /* 头像样式 */
  .avatar-container {
    position: relative;
    margin: 0 10px;
    flex-shrink: 0; /* 防止头像被压缩 */
  }
  .avatar-container .avatar {
      width: 48px;
      height: 48px;
      border-radius: 8px; /* 微信风格圆角矩形 */
  }

  /* 在线状态 */
  .online-status {
    position: absolute;
    top: -3px;
    right: -3px;
    width: 12px;
    height: 12px;
    background-color: #28a745;
    border: 2px solid white;
    border-radius: 50%;
    display: none; /* 默认不显示 */
  }
  .online-status.online {
    display: block; /* 在线时显示 */
  }

  /* 国旗 */
  .country-flag {
    position: absolute;
    bottom: -2px;
    right: -4px;
    width: 20px;
    height: 15px;
    background-size: cover;
    border: 1px solid #ddd;
    border-radius: 3px;
    box-shadow: 0 0 2px rgba(0,0,0,0.2);
  }

  /* 消息内容 */
  .message-content-wrapper {
      display: flex;
      flex-direction: column;
  }

  .message-body {
    padding: 10px 15px;
    font-size: 1rem;
    word-wrap: break-word;
    word-break: break-word;
    text-align: left;
  }

  /* 消息控制按钮 */
  .message-controls {
      opacity: 0;
      transition: opacity 0.2s ease-in-out;
      align-self: center;
      margin: 0 5px;
  }
  .chat-message:hover .message-controls {
      opacity: 1;
  }
  .message-controls .dropdown-toggle::after {
      display: none; /* 隐藏下拉菜单的小箭头 */
  }
</style>
