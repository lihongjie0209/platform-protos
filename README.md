# Platform Protos

平台服务间 gRPC 与事件的唯一契约源。前端 REST DTO 由各服务维护，不能直接暴露数据库模型。

```bash
buf lint
buf breaking --against '.git#branch=main'
buf generate
```

事件 subject 规范：`platform.<domain>.<aggregate>.<event>.v1`，例如：

- `platform.identity.user.status-changed.v1`
- `platform.identity.session.revoked.v1`
- `platform.tenant.membership.changed.v1`
- `platform.tenant.tenant.status-changed.v1`
- `platform.authorization.policy.changed.v1`

