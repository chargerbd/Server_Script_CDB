--
function c200000002.initial_effect(c)
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c200000002.cost)
	e3:SetTarget(c200000002.target)
	e3:SetOperation(c200000002.operation)
	c:RegisterEffect(e3)
end
c200000002.illegal=true
function c200000002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	c200000002.announce_filter={200000003,OPCODE_ISCODE,nil,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND}
	Duel.AnnounceCardFilter(tp,table.unpack(c200000002.announce_filter))
end
function c200000002.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x107f) and c:IsSetCard(0x1048) and c:IsType(TYPE_XYZ) and c:GetFlagEffect(200000002)==0
end
function c200000002.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and c200000002.spfilter(chkc) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c200000002.spfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c200000002.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c200000002.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		if Duel.GetFlagEffect(tp,200000000)>0 and Duel.GetFlagEffect(tp,200000004)>0 then
			tc:RegisterFlagEffect(200000002,RESET_EVENT+0x1220000+RESET_PHASE+PHASE_END,0,1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_BATTLE_DAMAGE)
			e2:SetCondition(c200000002.wincon)
			e2:SetOperation(c200000002.winop)
			e2:SetLabelObject(tc)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
function c200000002.wincon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return eg:IsContains(tc) and tc:GetFlagEffect(200000002)~=0 and ep~=tp and Duel.GetAttackTarget()==nil
end
function c200000002.winop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,200000002)
	local WIN_REASON_MIRACLE_CRETER=0x30
	Duel.Win(tp,WIN_REASON_MIRACLE_CRETER)
end
