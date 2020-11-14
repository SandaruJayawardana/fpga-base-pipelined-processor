def avoid_pipeline_hazard(codeline):
    if len(instruction_list)==(codeline+1):
        return "NOP"
    elif instruction_list[codeline][0]=="JUMPZ"or instruction_list[codeline][0]=="JUMPNZ" or len(present_reg_no)==14  :
        return "NOP"
    if instruction_list[codeline][0]=="WRITE" or instruction_list[codeline][0]=="READ":
        if "MDR" in present_reg_no or "MAR" in present_reg_no:
            if "MDR" not in present_reg_no:
                present_reg_no.append("MDR")
            if "MAR" not in present_reg_no:
                present_reg_no.append("MAR")
        else:
            return codeline
    
    return avoid_cache_hazard(codeline+1)

   
assembly_code = open("assembly_code.txt", "r") # FILE open. This file contains the assembly instructions.
#Read assembly code
assembly_text = assembly_code.read()
assembly_list = assembly_text.split('\n')
assembly_code.close()
#print (assembly_list)
instruction_list=[]
for i in range(len(assembly_list)):
    k=assembly_list[i]
    if "//" in k:
        #print (k)
        for j in range(len(k)):
            #print (k[j])
            if k[j]=="/":
                k=k[0:j]
                break
    k=k.split(' ')
    instruction=[]
    for l in k:
        if(l!=''):
            instruction.append(l)

        #return
    if len(instruction)==2:
        instruction=instruction[0:1]+instruction[1].split(',')
    instruction_list.append(instruction)

Assembly_inst=    ['NOP','ADD','SUB','XOR','MUL','DIV','JUMPZ','JUMPNZ','SUBI','ADDI','WRITE','READ','INCRE','MEMADD','MOV','CLAC','STOP']
Opcode_bin_code=['0000','0001','0010','0011','0100','0101','0110','0111','1000','1001','1010','1011','1100','1101','1110','1111','1111','11111111']
operands=['MAR','MDR','PC','R1','R2','R3','R4','R5','R6','R7','R8','AC','R_I_1','R_I_2','R_I_3']
operand_dic={'MAR': '0000','MDR': '0001','PC': '0010','R1': '0011','R2': '0100','R3': '0101','R4': '0110','R5': '0111','R6': '1000','R7': '1001','R8': '1010','R_I_1': '1011','R_I_2': '1100','R_I_3': '1101','AC': '1110'}



def macinecodegenerate(instruction_list):
    
    machine_no=[]
    instruction_list_without_comments=[]
    machinecode=[]
    zero_str="0000000000000000"
    machine_code_line=0
    for line_no in range(len(instruction_list)):
        machine_no.append(machine_code_line)
        position=instruction_list[line_no]
        #print ("position",position)
        if len(position)>0:
            
            instruction_list_without_comments.append(position)
            machinecode.append(0)
            if position[0]=='NOP':
                machinecode[machine_code_line]='0000000000000000'
            elif position[0]=='ADD':
                machinecode[machine_code_line]='0001'
            elif position[0]=='SUB':
                machinecode[machine_code_line]='0010'
            elif position[0]=='XOR':
                machinecode[machine_code_line]='0011'
            elif position[0]=='MUL':
                machinecode[machine_code_line]='0100'
            elif position[0]=='DIV':
                machinecode[machine_code_line]='0101'
            elif position[0]=='JUMPZ':
                machinecode[machine_code_line]='0110'
            elif position[0]=='JUMPNZ':
                machinecode[machine_code_line]='0111'
            elif position[0]=='SUBI':
                machinecode[machine_code_line]='1000'
            elif position[0]=='ADDI':
                machinecode[machine_code_line]='1001'
            elif position[0]=='WRITE':
                machinecode[machine_code_line]='1010000000000000'
            elif position[0]=='READ':
                machinecode[machine_code_line]='1011000000000000'
            elif position[0]=='INCRE':
                machinecode[machine_code_line]='1100'
            elif position[0]=='MEMADD':
                machinecode[machine_code_line]='1101'
            elif position[0]=='MOV':
                machinecode[machine_code_line]='1110'
            elif position[0]=='CLAC':
                machinecode[machine_code_line]='1111000000000000'
            elif position[0]=='STOP':
                machinecode[machine_code_line]='1111111100000000'
           
            if position[0] in Assembly_inst[1:6]:
                if len(position)!=4:
                    print ("Compile error line no:",line_no+1)
                    #return
                else:
                    i=position[1]
                    if i in operands:
                        machinecode[machine_code_line]=machinecode[machine_code_line]+operand_dic[i]
                        i=position[2]
                        if i in operands:
                            machinecode[machine_code_line]=machinecode[machine_code_line]+operand_dic[i]
                            i=position[3]
                            #if i in operands[1:12]:
                            machinecode[machine_code_line]=machinecode[machine_code_line]+operand_dic[i]
                      
            elif position[0]=='JUMPZ' or position[0]=='JUMPNZ':
                if len(position)!=2 :#check whether a number
                    pass
                else:
                    binaryno=str(bin(int(position[1])))[2:]
                    
                    if len(binaryno)<11:
                        machinecode[machine_code_line]=machinecode[machine_code_line]+zero_str[:12-len(binaryno)]+binaryno
                    
            elif position[0]=='ADDI' or position[0]=='SUBI':
                if len(position)!=4 :#check whether a number
                    pass
                else:
                    i=position[1]
                    if i in operands:
                        machinecode[machine_code_line]=machinecode[machine_code_line]+operand_dic[i]
                        i=position[2]
                        if i in operands:
                            machinecode[machine_code_line]=machinecode[machine_code_line]+operand_dic[i]+"0000"
                        
                    binaryno=str(bin(int(position[3])))[2:]
                    if len(binaryno)<17:
                        machinecode.append(0)
                        machine_code_line=machine_code_line+1
                        machinecode[machine_code_line]=zero_str[:16-len(binaryno)]+binaryno
                    
            elif position[0] == 'MOV':
                if len(position)!=3 :#check whether a number
                    pass
                else:
                    i=position[1]
                    if i in operands:
                        machinecode[machine_code_line]=machinecode[machine_code_line]+operand_dic[i]
                        i=position[2]
                        if i in operands:
                            machinecode[machine_code_line]=machinecode[machine_code_line]+operand_dic[i]+"0000"
                        
            elif position[0] == 'INCRE':
                if len(position)!=2 :#check whether a number
                    print ("Compile error line no:",line_no+1)
                    #return
                else:
                    i=position[1]
                    if i =="R_I_1":
                        machinecode[machine_code_line]=machinecode[machine_code_line]+"000100000000"
                    elif  i =="R_I_2":
                        machinecode[machine_code_line]=machinecode[machine_code_line]+"001000000000"
                    elif i =="R_I_3":
                        machinecode[machine_code_line]=machinecode[machine_code_line]+"001100000000"
                    elif i =="MAR":
                        machinecode[machine_code_line]=machinecode[machine_code_line]+"000000000000"
                    
            elif position[0] == 'MEMADD':
                if len(position)!=2 :#check whether a number
                   pass
                else:
                    binaryno=str(bin(int(position[1])))[2:]
                    
                    if len(binaryno)<19:
                        if len(binaryno)>16:
                            machinecode[machine_code_line]=machinecode[machine_code_line]+zero_str[:2-len(binaryno[16:])]+binaryno[16:]+"0000000000"
                            machine_code_line=machine_code_line+1
                            machinecode.append(0)
                            machinecode[machine_code_line]=zero_str[:16-len(binaryno)]+binaryno
                        else:
                            machinecode[machine_code_line]=machinecode[machine_code_line]+"000000000000"
                            machine_code_line=machine_code_line+1
                            machinecode.append(0)
                            machinecode[machine_code_line]=zero_str[:16-len(binaryno)]+binaryno
            
                
            machine_code_line=machine_code_line+1

    for i in range(len(instruction_list)):
        if len(instruction_list[i])>0:
            if instruction_list[i][0]=='JUMPZ' or instruction_list[i][0]=='JUMPNZ':
                #print ("________________",machine_no[int(instruction_list[i][1])])
                #print ("________________",(instruction_list[i][1]))
                binaryno=str(bin(machine_no[int(instruction_list[i][1])]))[2:]
                #print (machinecode[machine_no[i]],"wqwqw")
                machinecode[machine_no[i]]=machinecode[machine_no[i]][0:4]+zero_str[:12-len(binaryno)]+binaryno   
    return instruction_list_without_comments,machinecode
instruction_list_without_comments,machinecode=macinecodegenerate(instruction_list)       

present_reg_no=[]
new_code=[]
instruction_list=instruction_list_without_comments

for checkline in range(len(instruction_list)):
    if checkline < len(instruction_list)-1:
        if instruction_list[checkline][0]=="JUMPZ" or instruction_list[checkline][0]=="JUMPNZ" :
            
            new_code.append(checkline)
            new_code.append("NOP")
        elif instruction_list[checkline][0] in Assembly_inst[1:6]:
            if instruction_list[checkline+1][0] in Assembly_inst[1:6]:
                if instruction_list[checkline][1]==instruction_list[checkline+1][3] or instruction_list[checkline][1]==instruction_list[checkline+1][2]:
                    #avoid_cache_hazard(checkline)
                    new_code.append(checkline)
                    new_code.append("NOP")
                else:
                    new_code.append(checkline)
            elif instruction_list[checkline+1][0]=="MOV" or instruction_list[checkline+1][0]=="SUBI" or instruction_list[checkline+1][0]=="ADDI" :
                if instruction_list[checkline][1]==instruction_list[checkline+1][2] :
                    #avoid_cache_hazard(checkline)
                    new_code.append(checkline)
                    new_code.append("NOP")
                else:
                    new_code.append(checkline)
            else:
                new_code.append(checkline)
        elif instruction_list[checkline][0]=="MOV" or instruction_list[checkline][0]=="SUBI" or instruction_list[checkline][0]=="ADDI" :
            if instruction_list[checkline+1][0] in Assembly_inst[1:6]:
                if instruction_list[checkline][1]==instruction_list[checkline+1][3] or instruction_list[checkline][1]==instruction_list[checkline+1][2]:
                    #avoid_cache_hazard(checkline)
                    new_code.append(checkline)
                    new_code.append("NOP")
                else:
                    new_code.append(checkline)
            elif instruction_list[checkline+1][0]=="MOV" or instruction_list[checkline+1][0]=="SUBI" or instruction_list[checkline+1][0]=="ADDI" :
                if instruction_list[checkline][1]==instruction_list[checkline+1][2] :
                    #avoid_cache_hazard(checkline)
                    new_code.append(checkline)
                    new_code.append("NOP")
                else:
                    new_code.append(checkline)
            else:
                new_code.append(checkline)
        elif instruction_list[checkline][0]=="READ" :
            if instruction_list[checkline+1][0] in Assembly_inst[1:6]:
                if "MDR"==instruction_list[checkline+1][3] or "MDR"==instruction_list[checkline+1][2]:
                    #avoid_cache_hazard(checkline)
                    new_code.append(checkline)
                    new_code.append("NOP")
                else:
                    new_code.append(checkline)
            elif instruction_list[checkline+1][0]=="MOV" or instruction_list[checkline+1][0]=="SUBI" or instruction_list[checkline+1][0]=="ADDI" :
                if "MDR"==instruction_list[checkline+1][2] :
                    #avoid_cache_hazard(checkline)
                    new_code.append(checkline)
                    new_code.append("NOP")
                else:
                    new_code.append(checkline)
            else:
                new_code.append(checkline)
        elif instruction_list[checkline][0]=="INCRE" :
            if instruction_list[checkline+1][0] in Assembly_inst[1:6]:
                if instruction_list[checkline][1]==instruction_list[checkline+1][3] or instruction_list[checkline][1]==instruction_list[checkline+1][2]:
                    #avoid_cache_hazard(checkline)
                    new_code.append(checkline)
                    new_code.append("NOP")
                else:
                    new_code.append(checkline)
            elif instruction_list[checkline+1][0]=="MOV" or instruction_list[checkline+1][0]=="SUBI" or instruction_list[checkline+1][0]=="ADDI" :
                if instruction_list[checkline][1]==instruction_list[checkline+1][2] :
                    #avoid_cache_hazard(checkline)
                    new_code.append(checkline)
                    new_code.append("NOP")
                else:
                    new_code.append(checkline)
            else:
                new_code.append(checkline)
        elif instruction_list[checkline][0]=="MEMADD" :
            if instruction_list[checkline+1][0] in Assembly_inst[1:6]:
                if "MAR"==instruction_list[checkline+1][3] or "MAR"==instruction_list[checkline+1][2]:
                    #avoid_cache_hazard(checkline)
                    new_code.append(checkline)
                    new_code.append("NOP")
                else:
                    new_code.append(checkline)
            elif instruction_list[checkline+1][0]=="MOV" or instruction_list[checkline+1][0]=="SUBI" or instruction_list[checkline+1][0]=="ADDI" :
                if "MAR"==instruction_list[checkline+1][2] :
                    #avoid_cache_hazard(checkline)
                    new_code.append(checkline)
                    new_code.append("NOP")
                else:
                    new_code.append(checkline)
            else:
                new_code.append(checkline)
        elif instruction_list[checkline][0]=="STOP" :
            new_code.append("NOP")
            new_code.append("NOP")
            new_code.append(checkline)    
        else:
            new_code.append(checkline)
    elif instruction_list[checkline][0]=="STOP" :
        new_code.append("NOP")
        new_code.append("NOP")
        new_code.append(checkline)
    
    else:
        new_code.append(checkline)

instruction_list_without_comments=[]
inst_order=[]
inst_order_no=0;
for j in new_code:
    if j=="NOP":
        inst_order_no=inst_order_no+1;
        instruction_list_without_comments.append(['NOP'])

    else:
        inst_order.append(inst_order_no)
        inst_order_no=inst_order_no+1;
        i=instruction_list[j]
        instruction_list_without_comments.append(i)

for i in range(len(instruction_list_without_comments)):
    if instruction_list_without_comments[i][0]=='JUMPZ' or instruction_list_without_comments[i][0]=='JUMPNZ':
        instruction_list_without_comments[i][1]=inst_order[int(instruction_list_without_comments[i][1])]

instruction_list_without_comments,machinecode=macinecodegenerate(instruction_list_without_comments)
print("Machine Instructions\n\n")
for i  in range(len(machinecode)):       
    print ("mem["+str(i)+"]= 16'b"+str(machinecode[i])+";")
