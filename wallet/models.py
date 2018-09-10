from django.db import models


class Address(models.Model):
    coin_name = models.CharField(max_length=5)
    address = models.CharField(unique=True, max_length=100)
    encrpyted_private_key = models.TextField()
    is_used = models.IntegerField(blank=True, null=True)
    is_inner = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'address'


class AuthGroup(models.Model):
    name = models.CharField(unique=True, max_length=80)

    class Meta:
        managed = False
        db_table = 'auth_group'


class AuthGroupPermissions(models.Model):
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)
    permission = models.ForeignKey('AuthPermission', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_group_permissions'
        unique_together = (('group', 'permission'),)


class AuthPermission(models.Model):
    name = models.CharField(max_length=255)
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING)
    codename = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'auth_permission'
        unique_together = (('content_type', 'codename'),)


class AuthUser(models.Model):
    password = models.CharField(max_length=128)
    last_login = models.DateTimeField(blank=True, null=True)
    is_superuser = models.IntegerField()
    username = models.CharField(unique=True, max_length=150)
    first_name = models.CharField(max_length=30)
    last_name = models.CharField(max_length=30)
    email = models.CharField(max_length=254)
    is_staff = models.IntegerField()
    is_active = models.IntegerField()
    date_joined = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'auth_user'


class AuthUserGroups(models.Model):
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_user_groups'
        unique_together = (('user', 'group'),)


class AuthUserUserPermissions(models.Model):
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)
    permission = models.ForeignKey(AuthPermission, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_user_user_permissions'
        unique_together = (('user', 'permission'),)


class BalanceChange(models.Model):
    coin_name = models.CharField(max_length=5)
    tx_from_address = models.CharField(max_length=100, blank=True, null=True)
    tx_to_address = models.CharField(max_length=100, blank=True, null=True)
    tx_hash = models.CharField(unique=True, max_length=100, blank=True, null=True)
    tx_is_confirmed = models.IntegerField(blank=True, null=True)
    tx_amount = models.DecimalField(max_digits=19, decimal_places=8)
    tx_fee = models.DecimalField(max_digits=19, decimal_places=10, blank=True, null=True)
    balance_original = models.DecimalField(max_digits=19, decimal_places=10, blank=True, null=True)
    balance_now = models.DecimalField(max_digits=19, decimal_places=10, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'balance_change'


class CoinExchangeList(models.Model):
    source_coin_name = models.CharField(max_length=5, blank=True, null=True)
    target_coin_name = models.CharField(max_length=5, blank=True, null=True)
    rate = models.DecimalField(max_digits=19, decimal_places=8, blank=True, null=True)
    rate_update_time_stamp = models.IntegerField(blank=True, null=True)
    order_valid_seconds = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'coin_exchange_list'


class DjangoAdminLog(models.Model):
    action_time = models.DateTimeField()
    object_id = models.TextField(blank=True, null=True)
    object_repr = models.CharField(max_length=200)
    action_flag = models.SmallIntegerField()
    change_message = models.TextField()
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING, blank=True, null=True)
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'django_admin_log'


class DjangoContentType(models.Model):
    app_label = models.CharField(max_length=100)
    model = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'django_content_type'
        unique_together = (('app_label', 'model'),)


class DjangoMigrations(models.Model):
    app = models.CharField(max_length=255)
    name = models.CharField(max_length=255)
    applied = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_migrations'


class DjangoSession(models.Model):
    session_key = models.CharField(primary_key=True, max_length=40)
    session_data = models.TextField()
    expire_date = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_session'


class Order(models.Model):
    order_id = models.CharField(unique=True, max_length=100)
    source_coin_name = models.CharField(max_length=5)
    source_amount = models.DecimalField(max_digits=19, decimal_places=6)
    target_coin_name = models.CharField(max_length=5)
    target_amount = models.DecimalField(max_digits=19, decimal_places=6)
    create_time_stamp = models.IntegerField()
    rate = models.DecimalField(max_digits=19, decimal_places=6, blank=True, null=True)
    target_coin_address = models.CharField(max_length=100)
    source_coin_payment_address = models.CharField(max_length=100, blank=True, null=True)
    # transaction_in = models.ForeignKey('Transaction', models.DO_NOTHING, blank=True, null=True)
    # transaction_out = models.ForeignKey('Transaction', models.DO_NOTHING, blank=True, null=True)
    is_finished = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'order'


class Transaction(models.Model):
    coin_name = models.CharField(max_length=5)
    from_address = models.CharField(max_length=100, blank=True, null=True)
    to_address = models.CharField(max_length=100)
    tx_hash = models.CharField(unique=True, max_length=100, blank=True, null=True)
    is_to_address_mine = models.IntegerField(blank=True, null=True)
    is_from_address_mine = models.IntegerField(blank=True, null=True)
    amount = models.DecimalField(max_digits=19, decimal_places=8)
    fee = models.DecimalField(max_digits=19, decimal_places=10, blank=True, null=True)
    is_confirmed = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'transaction'
