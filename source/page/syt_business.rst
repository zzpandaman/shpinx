收银通相关业务逻辑
==============================

1. **补贴数据**

::

	补贴：posbill_fenrun
	SELECT f_state FStatus, F_amount FSubsidyAmount FROM posbill.t_merchant_zero_subsidy_transfer_bill " +
	                    "WHERE F_object_id_src =? and f_object_id_dst =? and f_date = ? 

	刷卡（交易总额，手续费）：posbill
	select sum(f_amount) f_amount, sum(f_merchant_commission) f_commission from posbill.t_merchant_t1_channel_bill_"+tableNum+
	                    " where f_order_id like '"+DateUtils.formatDate(date, "yyyyMMdd")+"%' and f_merchant_id = ?

	扫码（交易总额，手续费）：posbill_scan_merchant(53.3)
	select sum(F_amount) f_amount, sum(F_merchant_commission_amount) f_commission from posbill_scan_merchant.t_merchant_settle_account_"+tableNum+
	                    " where f_merchant_id = ? and DATE(from_unixtime(f_start_time,'%Y-%m-%d')) = ?

	打款金额：posbill
	SELECT ifnull(sum(f_real_amount),0) as total_amount from posbill.t_paybill_ordernew_" +tableNum+
	                    " where f_merchant_id= ? and f_state = 9 and f_date = ?

	交易详情：posbill_scan_merchant(53.3)
	select F_order_id,DATE(from_unixtime(F_time,'%Y-%m-%d %h:%i:%s')) as transTime,F_pay_type,F_operation_status,F_amount,F_fee_rate,F_merchant_commission_amount from t_merchant_order_settleinfo_" +tableNum+
                    " where F_merchant_id = ? and DATE(from_unixtime(F_time,'%Y-%m-%d')) = ?

2. **pc后台添加菜单**

::

	INSERT INTO `syt`.`t_syt_menu` ( `F_menu_id`, `F_menu_name`, `F_menu_url`, `F_parent_id`, `F_menu_type` ) VALUES ( 3003, '春笋奖励统计', '/activity/bambooReward', 30, 2 );
	INSERT INTO `syt`.`t_syt_menu` ( `F_menu_id`, `F_menu_name`, `F_menu_url`, `F_parent_id`, `F_menu_type` ) VALUES ( 3004, '/activity/bambooReward', '/activity/bambooPurchase', 30, 2 );

3. **六代白名单添加**

::

	UPDATE `lepos`.`t_agent_info` SET `F_is_three` = 1 WHERE `F_agent_id` in('7611065')

4. **一代初始化业务员信息**

::

	* 查询新增一代：
	select F_create_time from t_agent_info where F_agent_level=1 and F_agent_class=7 and F_sub_agent_class=5 order by F_create_time desc
	* 查异常初始化代理商：
	select F_agent_id,F_create_time  from t_agent_info where  F_agent_class=7 and F_sub_agent_class=5  and F_agent_level !=9 and F_agent_level !=10 and F_agent_id not in(
	select
	  F_agent_parent_id 
	from

	  t_syt_bd bd
	  inner JOIN t_syt_team t on bd.F_team_id = t.F_team_id
	  inner JOIN t_syt_city c on t.F_city_id = c.F_city_id
	  inner JOIN t_syt_zone z on z.F_zone_id = c.F_zone_id
	  where F_victual_flag = 1 and F_agent_parent_id in (
	  
	select F_agent_id from t_agent_info where  F_agent_class=7 and F_sub_agent_class=5  and F_agent_level !=9 and F_agent_level !=10 order by F_create_time asc)

	)
	select * from t_syt_bd where F_agent_parent_id='2735578'
	select * from t_syt_zone where F_agent_id='2735578'
	select * from t_syt_city where F_agent_id='2735578'
	select * from t_syt_team where F_agent_id='2735578'

5. **xxljob调试**

::

	curl -X POST 'http://172.20.33.142:8269/merchant/job/initAgent1gBdInfo?startSearchTime=2021-01-17%2014:25:54'
	curl 'http://172.20.34.127:8269//merchant/job/initAgent1gBdInfo?startSearchTime=2021-01-21%2014:25:54'
	curl 'http://172.20.34.127:8269//merchant/orderSystem/addAppIdConfig?merchantId=9613716423'
	curl 'http://172.20.61.181:8269//merchant/job/initAgent1gBdInfo?startSearchTime=2020-01-10%2014:25:54'

6. **代理商成本相关**

::

	微信支付宝费率取值
	SELECT
		F_t1_weixin_commission_bymillion,
		F_t1_weixin_activity_commission_bymillion,
		F_t0_weixin_commission_bymillion,
		F_t0_weixin_activity_commission_bymillion,
		F_t1_alipay_commission_bymillion,
		F_t0_alipay_commission_bymillion,
		F_t1_realname_commission_bymillion,
		F_t0_realname_commission_bymillion,
		IFNULL( F_lower_divide_cent, 0 ),
		ifnull( F_t1_commission_fixed_bymillion, 0 ),
		F_bus_type 
	FROM
		lepos.t_agent_nopos_cost_commission_conf_info 
	WHERE
		F_agent_id = '1560738' 
		AND F_bind_sn_flag = 0 
		AND F_bus_type = 0 
		AND F_start_date <= 20201227 
		AND F_start_count <= 0 AND F_end_count > 0 
		AND F_start_amount <= 0 AND F_end_amount > 0 
	ORDER BY
		F_start_date DESC 
		LIMIT 1

	* 代理商最高成本
	借记贷记
	UPDATE `lepos`.`t_agent_pos_cost_commission_conf_info` SET  `F_t1_debit_commission_bymillion` = 4200, `F_t1_debit_max_fee_bymillion` = 1900000000, `F_t1_credit_commission_bymillion` = 5300 WHERE `F_agent_id` = '1630905' AND `F_end_count` = -1 AND `F_start_count` = -1 AND `F_start_amount` = -1 AND `F_end_amount` = -1;

	微信支付宝
	UPDATE `lepos`.`t_agent_nopos_cost_commission_conf_info` SET `F_t1_weixin_commission_bymillion` = 2300, `F_t1_alipay_commission_bymillion` = 2300 WHERE `F_agent_id` = '1630905' AND `F_end_count` = -1 AND `F_start_count` = -1 AND `F_start_amount` = -1 AND `F_end_amount` = -1;

	千元以下银联
	UPDATE `lepos`.`t_agent_common_cost_commission_conf_info` SET `F_t1_debit_commission_bymillion` = 2500, `F_t1_debit_max_fee_bymillion` = 0, `F_t1_credit_commission_bymillion` = 2500 WHERE `F_agent_id` = '1630905' AND `F_pay_type` = 6  AND `F_end_count` = -1 AND `F_start_count` = -1 AND `F_start_amount` = -1 AND `F_end_amount` = -1;

	千元以上银联
	UPDATE `lepos`.`t_agent_common_cost_commission_conf_info` SET `F_t1_debit_commission_bymillion` = 5300, `F_t1_debit_max_fee_bymillion` = 1900000000, `F_t1_credit_commission_bymillion` = 5300 WHERE `F_agent_id` = '1630905' AND `F_pay_type` = 7  AND `F_end_count` = -1 AND `F_start_count` = -1 AND `F_start_amount` = -1 AND `F_end_amount` = -1;