package com.yohann.ocihelper.bean.params.oci.instance;

import lombok.Data;

import jakarta.validation.constraints.NotBlank;

/**
 * <p>
 * GetInstanceCfgInfoParams
 * </p >
 *
 * @author yuhui.fan
 * @since 2024/12/18 18:02
 */
@Data
public class GetInstanceCfgInfoParams {

    @NotBlank(message = "配置id不能为空")
    private String ociCfgId;

    @NotBlank(message = "实例id不能为空")
    private String instanceId;
}
