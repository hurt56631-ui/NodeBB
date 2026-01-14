<!-- BEGIN messages -->
<li
  component="chat/message"
  class="chat-message chat-message-custom mx-2 pe-2 {{{ if messages.newSet }}}border-top pt-3{{{ end }}} {{{ if messages.self }}}self{{{ else }}}other{{{ end }}}"
  data-mid="{messages.messageId}"
  data-uid="{messages.fromUser.uid}"
>
  <div class="message-container">
    <div class="avatar-container">
      <a href="{config.relative_path}/user/{messages.fromUser.userslug}">
        {buildAvatar(messages.fromUser, "48px", true, "not-responsive")}
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
  </div>
</li>
<!-- END messages -->
