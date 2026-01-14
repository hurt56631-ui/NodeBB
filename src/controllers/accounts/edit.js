'use strict';

const user = require('../../user');
const meta = require('../../meta');
const helpers = require('../helpers');
const groups = require('../../groups');
const privileges = require('../../privileges');
const plugins = require('../../plugins');
const file = require('../../file');
const accountHelpers = require('./helpers');
const _ = require('lodash');

const editController = module.exports;

// GET 逻辑：负责把数据从数据库拿出来交给网页
editController.get = async function (req, res, next) {
	const { userData } = res.locals;
	if (!userData) {
		return next();
	}

	// --- 关键修正：确保从数据库拿出 nationality 和 location ---
	const extraFields = await user.getUserFields(userData.uid, ['nationality', 'location']);
	Object.assign(userData, extraFields);
	// -------------------------------------------------------

	const {
		username, userslug, isSelf, reputation,
		groups: _groups, groupTitleArray, allowMultipleBadges,
	} = userData;

	const [canUseSignature, canManageUsers, customUserFields] = await Promise.all([
		privileges.global.can('signature', req.uid),
		privileges.admin.can('admin:users', req.uid),
		accountHelpers.getCustomUserFields(req.uid, userData),
	]);

	userData.customUserFields = customUserFields;
	userData.maximumSignatureLength = meta.config.maximumSignatureLength;
	userData.maximumAboutMeLength = meta.config.maximumAboutMeLength;
	userData.allowMultipleBadges = meta.config.allowMultipleBadges === 1;
	userData.allowAccountDelete = meta.config.allowAccountDelete === 1;
	userData.allowAboutMe = !isSelf || !!meta.config['reputation:disabled'] || reputation >= meta.config['min:rep:aboutme'];
	userData.allowSignature = canUseSignature && (!isSelf || !!meta.config['reputation:disabled'] || reputation >= meta.config['min:rep:signature']);
	userData.profileImageDimension = meta.config.profileImageDimension;
	userData.defaultAvatar = user.getDefaultAvatar();
	userData.groups = _groups.filter(g => g && g.userTitleEnabled && !groups.isPrivilegeGroup(g.name) && g.name !== 'registered-users');

	if (req.uid === res.locals.uid || canManageUsers) {
		const { associations } = await plugins.hooks.fire('filter:auth.list', { uid: res.locals.uid, associations: [] });
		userData.sso = associations;
	}

	userData.groups.forEach((group) => {
		group.userTitle = group.userTitle || group.displayName;
		group.selected = groupTitleArray.includes(group.name);
	});

	userData.title = `[[pages:account/edit, ${username}]]`;
	userData.breadcrumbs = helpers.buildBreadcrumbs([{ text: username, url: `/user/${userslug}` }, { text: '[[user:edit]]' }]);
	
	res.render('account/edit', userData);
};

// --- 关键修正：必须叫 post 才能接收表单提交 ---
editController.post = async function (req, res) {
	// 获取当前正在被编辑的用户 UID
	const targetUid = await user.getUidByUserslug(req.params.userslug);
	if (!targetUid) { return res.status(404).json({message: "User not found"}); }

	// 权限检查
	const canEdit = await privileges.users.canEdit(req.uid, targetUid);
	if (!canEdit) { return res.status(403).json({message: "No Privilege"}); }

	// 白名单：只有在这里的字段才会被存入数据库
	const allowedFields = ['fullname', 'birthday', 'location', 'nationality', 'aboutme', 'signature'];
	const data = _.pick(req.body, allowedFields);
	data.uid = targetUid;

	try {
		await user.updateProfile(req.uid, data, allowedFields);
		res.json({ message: '[[user:profile-updated]]' });
	} catch (err) {
		res.status(400).json({ message: err.message });
	}
};

// 以下原始逻辑保持不变
editController.password = async function (req, res, next) { await renderRoute('password', req, res, next); };
editController.username = async function (req, res, next) { await renderRoute('username', req, res, next); };
editController.email = async function (req, res, next) {
	const targetUid = await user.getUidByUserslug(req.params.userslug);
	if (!targetUid || req.uid !== parseInt(targetUid, 10)) { return next(); }
	helpers.redirect(res, '/register/complete');
};
async function renderRoute(name, req, res) {
	const { userData } = res.locals;
	const [isAdmin, { username, userslug }, hasPassword] = await Promise.all([
		privileges.admin.can('admin:users', req.uid),
		user.getUserFields(res.locals.uid, ['username', 'userslug']),
		user.hasPassword(res.locals.uid),
	]);
	userData.hasPassword = hasPassword;
	userData.title = `[[pages:account/edit/${name}, ${username}]]`;
	res.render(`account/edit/${name}`, userData);
}
editController.uploadPicture = async function (req, res, next) {
	const userPhoto = req.files[0];
	try {
		const updateUid = await user.getUidByUserslug(req.params.userslug);
		const image = await user.uploadCroppedPictureFile({ callerUid: req.uid, uid: updateUid, file: userPhoto });
		res.json([{ name: userPhoto.name, url: image.url }]);
	} catch (err) { next(err); } finally { await file.delete(userPhoto.path); }
};
