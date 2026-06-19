import Foundation

class BlockMapper {
    
    static let shared = BlockMapper()
    
    private var opcodeMap: [String: String] = [:]
    
    private init() {
        setupOpcodeMap()
    }
    
    private func setupOpcodeMap() {
        opcodeMap["event_whenflagclicked"] = "当绿旗被点击"
        opcodeMap["event_whenkeypressed"] = "当按下指定键时"
        opcodeMap["event_whenthisspriteclicked"] = "当角色被点击时"
        opcodeMap["event_whentouchingobject"] = "当碰到对象时"
        opcodeMap["event_whenstageclicked"] = "当舞台被点击时"
        opcodeMap["event_whenbackdropswitchesto"] = "当背景切换时"
        opcodeMap["event_whengreaterthan"] = "当变量大于指定值时"
        opcodeMap["event_whenbroadcastreceived"] = "当接收到广播时"
        opcodeMap["event_broadcast"] = "广播消息"
        opcodeMap["event_broadcastandwait"] = "广播并等待"
        
        opcodeMap["motion_movesteps"] = "移动指定步数"
        opcodeMap["motion_gotoxy"] = "移动到指定坐标"
        opcodeMap["motion_goto"] = "移动到指定目标"
        opcodeMap["motion_turnright"] = "右转指定角度"
        opcodeMap["motion_turnleft"] = "左转指定角度"
        opcodeMap["motion_pointindirection"] = "面向指定方向"
        opcodeMap["motion_pointtowards"] = "面向指定目标"
        opcodeMap["motion_glidesecstoxy"] = "滑行到坐标"
        opcodeMap["motion_glideto"] = "滑行到目标"
        opcodeMap["motion_ifonedgebounce"] = "碰到边缘反弹"
        opcodeMap["motion_setrotationstyle"] = "设置旋转方式"
        opcodeMap["motion_changexby"] = "x坐标增加"
        opcodeMap["motion_setx"] = "设置x坐标"
        opcodeMap["motion_changeyby"] = "y坐标增加"
        opcodeMap["motion_sety"] = "设置y坐标"
        opcodeMap["motion_xposition"] = "报告x坐标"
        opcodeMap["motion_yposition"] = "报告y坐标"
        opcodeMap["motion_direction"] = "报告方向"
        
        opcodeMap["looks_say"] = "说话"
        opcodeMap["looks_sayforsecs"] = "说话指定秒数"
        opcodeMap["looks_think"] = "思考"
        opcodeMap["looks_thinkforsecs"] = "思考指定秒数"
        opcodeMap["looks_show"] = "显示角色"
        opcodeMap["looks_hide"] = "隐藏角色"
        opcodeMap["looks_switchcostumeto"] = "切换造型"
        opcodeMap["looks_switchbackdropto"] = "切换背景"
        opcodeMap["looks_switchbackdroptoandwait"] = "切换背景并等待"
        opcodeMap["looks_nextcostume"] = "下一个造型"
        opcodeMap["looks_nextbackdrop"] = "下一个背景"
        opcodeMap["looks_changeeffectby"] = "改变特效"
        opcodeMap["looks_seteffectto"] = "设置特效"
        opcodeMap["looks_cleargraphiceffects"] = "清除特效"
        opcodeMap["looks_changesizeby"] = "将角色大小增加"
        opcodeMap["looks_setsizeto"] = "设置大小"
        opcodeMap["looks_gotofrontback"] = "移到最前/最后"
        opcodeMap["looks_goforwardbackwardlayers"] = "前移/后移多层"
        opcodeMap["looks_size"] = "报告大小"
        opcodeMap["looks_costumenumbername"] = "报告造型编号/名称"
        opcodeMap["looks_backdropnumbername"] = "报告背景编号/名称"
        
        opcodeMap["sound_play"] = "播放声音"
        opcodeMap["sound_playuntildone"] = "播放直到完成"
        opcodeMap["sound_stopallsounds"] = "停止所有声音"
        opcodeMap["sound_seteffectto"] = "设置声音特效"
        opcodeMap["sound_changeeffectby"] = "改变声音特效"
        opcodeMap["sound_cleareffects"] = "清除声音特效"
        opcodeMap["sound_setvolumeto"] = "设置音量"
        opcodeMap["sound_changevolumeby"] = "改变音量"
        opcodeMap["sound_volume"] = "报告音量"
        
        opcodeMap["control_wait"] = "等待指定秒数"
        opcodeMap["control_wait_until"] = "等待直到条件成立"
        opcodeMap["control_repeat"] = "重复执行指定次数"
        opcodeMap["control_repeat_until"] = "重复直到条件成立"
        opcodeMap["control_while"] = "当条件成立时重复"
        opcodeMap["control_forever"] = "永远重复执行"
        opcodeMap["control_if"] = "如果条件成立则执行"
        opcodeMap["control_if_else"] = "如果...否则..."
        opcodeMap["control_stop"] = "停止脚本"
        opcodeMap["control_create_clone_of"] = "创建克隆体"
        opcodeMap["control_start_as_clone"] = "当作为克隆体启动时"
        opcodeMap["control_delete_this_clone"] = "删除此克隆体"
        
        opcodeMap["sensing_touchingobject"] = "是否碰到对象"
        opcodeMap["sensing_touchingcolor"] = "是否碰到颜色"
        opcodeMap["sensing_coloristouchingcolor"] = "颜色是否碰到颜色"
        opcodeMap["sensing_distanceto"] = "到指定对象的距离"
        opcodeMap["sensing_timer"] = "计时器时间"
        opcodeMap["sensing_resettimer"] = "重置计时器"
        opcodeMap["sensing_of"] = "获取对象属性"
        opcodeMap["sensing_mousex"] = "鼠标x坐标"
        opcodeMap["sensing_mousey"] = "鼠标y坐标"
        opcodeMap["sensing_setdragmode"] = "设置拖拽模式"
        opcodeMap["sensing_mousedown"] = "鼠标是否按下"
        opcodeMap["sensing_keypressed"] = "按键是否按下"
        opcodeMap["sensing_current"] = "当前时间/日期"
        opcodeMap["sensing_dayssince2000"] = "自2000年以来的天数"
        opcodeMap["sensing_loudness"] = "音量"
        opcodeMap["sensing_loud"] = "是否大声"
        opcodeMap["sensing_answer"] = "回答的内容"
        opcodeMap["sensing_askandwait"] = "询问并等待"
        opcodeMap["sensing_username"] = "用户名"
        
        opcodeMap["operator_add"] = "加法"
        opcodeMap["operator_subtract"] = "减法"
        opcodeMap["operator_multiply"] = "乘法"
        opcodeMap["operator_divide"] = "除法"
        opcodeMap["operator_lt"] = "小于比较"
        opcodeMap["operator_equals"] = "等于比较"
        opcodeMap["operator_gt"] = "大于比较"
        opcodeMap["operator_and"] = "与运算"
        opcodeMap["operator_or"] = "或运算"
        opcodeMap["operator_not"] = "非运算"
        opcodeMap["operator_random"] = "取随机数"
        opcodeMap["operator_join"] = "连接字符串"
        opcodeMap["operator_letter_of"] = "获取字符"
        opcodeMap["operator_length"] = "字符串长度"
        opcodeMap["operator_contains"] = "字符串是否包含"
        opcodeMap["operator_mod"] = "取余数"
        opcodeMap["operator_round"] = "四舍五入"
        opcodeMap["operator_mathop"] = "数学函数"
        
        opcodeMap["data_variable"] = "报告变量值"
        opcodeMap["data_setvariableto"] = "设置变量值"
        opcodeMap["data_changevariableby"] = "变量值增加"
        opcodeMap["data_showvariable"] = "显示变量"
        opcodeMap["data_hidevariable"] = "隐藏变量"
        opcodeMap["data_listcontents"] = "列表内容"
        opcodeMap["data_addtolist"] = "添加到列表"
        opcodeMap["data_deleteoflist"] = "删除列表项"
        opcodeMap["data_deletealloflist"] = "删除所有项"
        opcodeMap["data_insertatlist"] = "在指定位置插入"
        opcodeMap["data_replaceitemoflist"] = "替换列表项"
        opcodeMap["data_itemoflist"] = "获取指定项"
        opcodeMap["data_itemnumoflist"] = "获取项的位置"
        opcodeMap["data_lengthoflist"] = "列表长度"
        opcodeMap["data_listcontainsitem"] = "列表是否包含项"
        opcodeMap["data_showlist"] = "显示列表"
        opcodeMap["data_hidelist"] = "隐藏列表"
        
        opcodeMap["clear"] = "全部擦除"
        opcodeMap["stamp"] = "盖章"
        opcodeMap["penDown"] = "落笔"
        opcodeMap["penUp"] = "抬笔"
        opcodeMap["setPenColorToColor"] = "设置画笔颜色"
        opcodeMap["changePenColorParamBy"] = "改变颜色参数"
        opcodeMap["setPenColorParamTo"] = "设置颜色参数"
        opcodeMap["changePenSizeBy"] = "改变画笔粗细"
        opcodeMap["setPenSizeTo"] = "设置画笔粗细"
    }
    
    func getBlockName(opcode: String) -> String {
        return opcodeMap[opcode] ?? opcode
    }
    
    func parseBlockValue(block: SB3Block) -> String {
        let name = getBlockName(opcode: block.opcode)
        
        var params: [String] = []
        
        if let inputs = block.inputs {
            for (_, input) in inputs {
                if input.count >= 2 {
                    let value = input[1]
                    if let array = value as? [Any], array.count >= 2 {
                        if let str = array[1] as? String {
                            params.append(str)
                        } else if let num = array[1] as? Double {
                            params.append(String(Int(num)))
                        } else if let num = array[1] as? Int {
                            params.append(String(num))
                        }
                    }
                }
            }
        }
        
        if let fields = block.fields {
            for (_, field) in fields {
                if !field.isEmpty {
                    if let str = field[0] as? String {
                        params.append(str)
                    } else if let num = field[0] as? Double {
                        params.append(String(Int(num)))
                    } else if let num = field[0] as? Int {
                        params.append(String(num))
                    }
                }
            }
        }
        
        if params.isEmpty {
            return name
        }
        
        return "\(name)：\(params.joined(separator: " "))"
    }
    
    func parseBlockChain(blocks: [SB3Block]) -> [String] {
        var result: [String] = []
        
        for block in blocks {
            result.append(parseBlockValue(block: block))
        }
        
        return result
    }
}
