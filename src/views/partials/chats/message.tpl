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
        <!-- 国旗 -->
        <div class="country-flag" style="background-image: url('/path/to/flags/{messages.fromUser.countryCode}.png');"></div>
      </a>
    </div>

    <div class="message-content-wrapper">
      <div class="message-header">
        <span class="chat-user fw-semibold"><a href="{config.relative_path}/user/{messages.fromUser.userslug}" class="text-decoration-none">{messages.fromUser.displayname}</a></span>
        <span class="chat-timestamp text-muted timeago" title="{messages.timestampISO}"></span>
      </div>
      <div component="chat/message/body" class="message-body">
        {messages.content}
      </div>
       <!-- 消息状态，例如已读 -->
      <div class="message-status">
        <!-- 这里可以放置已读回执等状态图标 -->
      </div>
    </div>

    <div component="chat/message/controls" class="message-controls">
        <div class="btn-group">
            <button class="btn btn-sm btn-link dropdown-toggle" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                <i class="fa fa-ellipsis-h"></i>
            </button>
            <ul class="dropdown-menu dropdown-menu-end p-1 text-sm list-unstyled" role="menu">
                <li><a href="#" class="dropdown-item rounded-1" data-action="reply" role="menuitem"><i class="fa fa-fw fa-reply text-muted"></i> 回复</a></li>
                <li><a href="#" class="dropdown-item rounded-1" data-action="read-aloud" data-mid="{messages.messageId}" role="menuitem"><i class="fa fa-fw fa-volume-up text-muted"></i> 朗读</a></li>

                {{{ if (isAdminOrGlobalMod || (!config.disableChatMessageEditing && messages.self)) }}}
                <li><a href="#" class="dropdown-item rounded-1" data-action="edit" role="menuitem"><i class="fa fa-fw fa-pencil text-muted"></i> 编辑</a></li>
                <li><a href="#" class="dropdown-item rounded-1" data-action="correct" role="menuitem"><i class="fa fa-fw fa-check text-muted"></i> 改错</a></li>
                <li><a href="#" class="dropdown-item rounded-1" data-action="withdraw-delete" data-timestamp="{messages.timestamp}" role="menuitem"><i class="fa fa-fw fa-history text-muted"></i> <span class="withdraw-delete-text">撤回</span></a></li>
                {{{ end }}}

                {{{ if isAdminOrGlobalMod }}}
                <li class="dropdown-divider"></li>
                <li><a href="#" class="dropdown-item rounded-1" data-action="pin" role="menuitem"><i class="fa fa-fw fa-thumbtack text-muted"></i> 置顶</a></li>
                {{{ end }}}
            </ul>
        </div>
    </div>
  </div>
</li>
<!-- END messages -->

<!-- 将所有CSS样式和JS脚本直接内联到模板中 -->
<style>
  /* 基础消息样式 */
  .chat-message {
    display: flex;
    margin-bottom: 15px;
    list-style-type: none;
  }
  .chat-message .message-container {
    display: flex;
    max-width: 80%;
    align-items: flex-end;
  }

  /* 他人消息 (左侧) */
  .chat-message.other {
    justify-content: flex-start;
  }
  .chat-message.other .message-container {
    flex-direction: row;
  }
  .chat-message.other .message-body {
    background-color: #f1f1f1;
    color: #333;
    border-radius: 18px 18px 18px 4px;
  }
  .chat-message.other .message-header {
    text-align: left;
    margin-left: 10px;
  }

  /* 自己消息 (右侧) */
  .chat-message.self {
    justify-content: flex-end;
  }
  .chat-message.self .message-container {
    flex-direction: row-reverse;
  }
  .chat-message.self .message-body {
    background-color: #007bff;
    color: white;
    border-radius: 18px 18px 4px 18px;
  }
   .chat-message.self .message-header {
    text-align: right;
    margin-right: 10px;
  }
  .chat-message.self .chat-user,
  .chat-message.self .chat-timestamp {
      display: none; /* 自己的消息不显示昵称和时间戳头部 */
  }


  /* 头像样式 */
  .avatar-container {
    position: relative;
    margin: 0 10px;
  }
  .avatar-container .avatar {
      width: 48px;
      height: 48px;
      border-radius: 50%;
  }

  /* 在线状态 */
  .online-status {
    position: absolute;
    top: 0;
    right: 0;
    width: 12px;
    height: 12px;
    background-color: #ccc;
    border: 2px solid white;
    border-radius: 50%;
  }
  .online-status.online {
    background-color: #28a745; /* 绿色表示在线 */
  }

  /* 国旗 */
  .country-flag {
    position: absolute;
    bottom: 0;
    right: -2px;
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
  .message-header {
      margin-bottom: 5px;
      font-size: 0.8rem;
      color: #888;
  }
  .message-body {
    padding: 10px 15px;
    font-size: 1rem;
    word-wrap: break-word;
  }

  /* 被改错的文字标记 */
  .corrected-char {
      color: red;
      text-decoration: underline;
  }

  /* 消息控制按钮 */
  .message-controls {
      opacity: 0;
      transition: opacity 0.2s ease-in-out;
      align-self: center;
      margin: 0 10px;
  }
  .chat-message:hover .message-controls {
      opacity: 1;
  }

  /* 屏蔽浏览器默认菜单 */
  .chat-message {
      -webkit-touch-callout: none; /* iOS Safari */
      -webkit-user-select: none; /* Safari */
      -khtml-user-select: none; /* Konqueror HTML */
      -moz-user-select: none; /* Old versions of Firefox */
      -ms-user-select: none; /* Internet Explorer/Edge */
      user-select: none; /* Non-prefixed version, currently supported by Chrome, Edge, Opera and Firefox */
  }
</style>

<script>
  // 等待DOM加载完成
  document.addEventListener('DOMContentLoaded', function() {
    // 朗读功能
    window.readAloud = function(messageId) {
      const messageElement = document.querySelector(`[data-mid="${messageId}"] .message-body`);
      if (messageElement) {
        const textToRead = messageElement.innerText;
        const ttsUrl = `https://t.leftsite.cn/api/audio?text=${encodeURIComponent(textToRead)}&speaker=zh-CN-XiaoxiaoMultilingualNeural`;
        const audio = new Audio(ttsUrl);
        audio.play().catch(e => console.error("朗读失败:", e));
      }
    };

    // 绑定朗读按钮事件
    document.querySelectorAll('[data-action="read-aloud"]').forEach(button => {
      button.addEventListener('click', function(e) {
        e.preventDefault();
        const messageId = this.getAttribute('data-mid');
        readAloud(messageId);
      });
    });

    // 撤回/删除逻辑
    document.querySelectorAll('[data-action="withdraw-delete"]').forEach(button => {
      const timestamp = parseInt(button.getAttribute('data-timestamp'), 10);
      const now = Date.now();
      const twoMinutes = 2 * 60 * 1000;

      const textSpan = button.querySelector('.withdraw-delete-text');
      if (now - timestamp > twoMinutes) {
        textSpan.innerText = '删除';
        // 绑定的后端action应为删除
        button.setAttribute('data-action', 'delete');
      } else {
        textSpan.innerText = '撤回';
        // 绑定的后端action应为撤回
        button.setAttribute('data-action', 'withdraw');
      }
      // 这里你需要根据NodeBB的API来实际触发删除或撤回事件
    });

    // 改错功能示例：点击后将文本变为可编辑状态
    document.querySelectorAll('[data-action="correct"]').forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            const messageBody = this.closest('.message-container').querySelector('.message-body');
            messageBody.setAttribute('contenteditable', 'true');
            messageBody.focus();
            // 在这里你可以添加更复杂的逻辑，比如显示保存和取消按钮
            // 并在用户完成编辑后，比较新旧文本，用 <span class="corrected-char"> 标签包裹不同的字符
        });
    });
  });
</script>
