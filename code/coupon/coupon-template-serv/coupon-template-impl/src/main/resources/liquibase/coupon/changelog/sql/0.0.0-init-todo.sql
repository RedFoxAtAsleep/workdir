CREATE TABLE coupon_template (
  id serial NOT NULL,
  available boolean NOT NULL DEFAULT false ,
  name varchar(64) NOT NULL DEFAULT '',
  description varchar(256) NOT NULL DEFAULT '',
  type varchar(10) NOT NULL DEFAULT '',
  shop_id bigint,
  updated_time timestamp NOT NULL DEFAULT NOW(),
  created_time timestamp NOT NULL DEFAULT NOW(),
  /*created_time timestamp NOT NULL DEFAULT current_timestamp,*/
  rule varchar(2000) NOT NULL DEFAULT '',
  PRIMARY KEY (id)
);
CREATE INDEX idx_shop_id ON coupon_template (shop_id);

comment on table coupon_template is '优惠券模板';
comment on column coupon_template.id is 'ID';
comment on column coupon_template.available is '优惠券可用状态';
comment on column coupon_template.name is '优惠券名称';
comment on column coupon_template.description is '优惠券详细信息';
comment on column coupon_template.type is '优惠券类型，比如满减、随机立减、晚间双倍等等';
comment on column coupon_template.shop_id is '优惠券适用的门店，如果是空则代表全场适用';
comment on column coupon_template.updated_time is '更新时间';
comment on column coupon_template.created_time is '创建时间';
comment on column coupon_template.rule is '详细的使用规则';

CREATE TABLE coupon (
  id serial NOT NULL,
  template_id integer NOT NULL DEFAULT 0,
  user_id bigint NOT NULL DEFAULT 0,
  status integer NOT NULL DEFAULT 0,
  shop_id bigint,
  created_time timestamp NOT NULL DEFAULT NOW(),
  updated_time timestamp NOT NULL DEFAULT NOW(),
  PRIMARY KEY (id)
);
CREATE INDEX idx_user_id ON coupon (user_id);
CREATE INDEX idx_template_id ON coupon (template_id);

comment on table coupon is '领到手的优惠券';
comment on column coupon.id is 'ID';
comment on column coupon.template_id is '模板ID';
comment on column coupon.user_id is '拥有这张券的用户ID';
comment on column coupon.status is '优惠券的状态，比如未用，已用';
comment on column coupon.shop_id is '优惠券适用的门店,冗余字段，方便查找';
comment on column coupon.updated_time is '更新时间';
comment on column coupon.created_time is '领券时间';