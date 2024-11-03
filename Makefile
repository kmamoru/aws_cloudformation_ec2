cf_file := stack.yml

stack_name := project1-ec2-${EnvName}

stack_input_file := ${EnvName}/cli-input.stack.json
change_set_input_file := ${EnvName}/cli-input.change-set.json

change_set_name := $(shell date +ChnageSet%Y%m%d%H%M%S)


.PHONY: validate-template gen-stack-skeleton gen-change-set-skeleton gen-stack-json gen-change-set-json create-stack create-change-set describe-change-set execute-change-set create-env

validate-template:
	aws cloudformation validate-template --template-body file://./${cf_file}

gen-stack-skeleton:
	aws cloudformation create-stack --stack-name hoge \
		--generate-cli-skeleton

gen-stack-json:
	envsubst < ${stack_input_file} > ${EnvName}/cli-input-create-stack.json


gen-change-set-json:
	envsubst < ${change_set_input_file} > ${EnvName}/cli-input-create-change-set.json


create-stack:
	aws cloudformation create-stack \
		--stack-name ${stack_name} \
		--template-body file://./${cf_file} \
		--cli-input-json file://./${EnvName}/cli-input-create-stack.json



stack-create-complete:
	aws cloudformation wait stack-create-complete \
	--stack-name "${stack_name}"


create-change-set:
	@echo $(chagne_set_name) > .change-set-name
	aws cloudformation create-change-set \ 
		--stack-name ${stack_name} \
		--change-set-name ${change_set_name} \
		--template-body file://./${cf_file} \
		--cli-input-json file://./${EnvName}/cli-input-create-change-set.json


describe-change-set:
	aws cloudformation describe-change-set \
		--stack-name ${stack_name} \
		--change-set-name $(shell cat .change-set-name)

execute-change-set:
	aws cloudformation execute-change-set \
		--stack-name ${stack_name} \
		--change-set-name $(shell cat .change-set-name)

create-env: create-stack stack-input-complete

delete-stack:
	aws cloudformation delete-stack --stack-name ${stack_name}


