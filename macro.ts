#!/usr/bin/env bun
// TODO: implement else, nesting ifdefs, and whatever else
import fs from 'node:fs/promises'
type DefinedMacros = { [key: string]: string }
interface CmdContext {
	lines: string[];
	defined: DefinedMacros;
	addToOutput(s: string): any;
	setState(st: string): any;
	getState(): string;
	infoStack: any[];
	lineIndex: number;
	line: string;
	filename: string;
	data: MacroVarData;
}
interface MacroVarData {
	block: {
		index: number;
		stack: string[];
	}
}
interface MacroProcessorOutput {
	final: string;
	processed: string;
	vars: DefinedMacros;
}
function errorMsgString(ctx: CmdContext, err: string) {
	return `${ctx.filename}:${ctx.lineIndex+1}: ${err}`;
}
function errorMsg(ctx: CmdContext, err: string) {
	console.error(errorMsgString(ctx, err));
}
const macroActions: { [key: string]: (context: CmdContext, args: any[]) => any } = {
	endifdef(ctx: CmdContext, args: string[]) {
		const text = args[0];
		const shouldInclude = ctx.infoStack.pop();
		if (ctx.data.block.index > 1) {
			if (shouldInclude) {
				ctx.data.block.stack.push(text);
			}
		}
		/*if (shouldInclude) {
			ctx.addToOutput(text);
		}*/
		if (--ctx.data.block.index == 0) {
			ctx.setState('normal');
			//console.log("blocks:", ctx.data.blockStack);
			if (shouldInclude) ctx.addToOutput(ctx.data.block.stack.join(''));
		}
	}
};
const macroCmds: { [key: string]: (args: string[], context: CmdContext) => any } = {
	define(args: string[], ctx: CmdContext) {
		const [name, ...rest] = args;
		const restStr = rest.join(' ');
		ctx.defined[name] = restStr;
	},
	ifdef(args: string[], ctx: CmdContext) {
		ctx.data.block.index++;
		ctx.setState('blockRead')
		ctx.infoStack.push(ctx.defined.hasOwnProperty(args[0]));
		ctx.infoStack.push('endifdef')
		ctx.infoStack.push('');
	},
	ifndef(args: string[], ctx: CmdContext) {
		ctx.data.block.index++;
		ctx.setState('blockRead')
		ctx.infoStack.push(!ctx.defined.hasOwnProperty(args[0]));
		ctx.infoStack.push('endifdef');
		ctx.infoStack.push('');
	},
	end(args: string[], ctx: CmdContext) {
		switch (ctx.getState()) {
			case 'normal': {
				errorMsg(ctx, "Invalid use of 'end'");
				break;
			}
			case 'blockRead': {
				const text = ctx.infoStack.pop();
				const action = ctx.infoStack.pop();
				if (!macroActions.hasOwnProperty(action)) {
					errorMsg(ctx, `Unknown stack action: ${action}`);
					break;
				} // its up to the macro action to return the state to 'normal'
				macroActions[action](ctx, [text]);
				break;
			}
		}
	},
	debug(args: string[], ctx: CmdContext) {
		switch (args[0]) {
			case "stack":
				console.log(ctx.infoStack);
				break;
			case "ctx":
				console.log(ctx);
				break;
			case "data":
				console.log(ctx.data);
				break;
		}
	}
};
function performMacroReplacements(text: string, defined: DefinedMacros) {
	let output = text;
	for (const key in defined) {
		const val = defined[key];
		output = output.replaceAll(key, val);
	}
	return output;
}
function processMacros(fname: string, text: string, predefines: DefinedMacros | null | undefined): MacroProcessorOutput {
	const lines = text.split('\n');
	const defined: DefinedMacros = predefines || {};
	let output = "";
	let state = "normal";
	const infoStack: any[] = [];
	const data: MacroVarData = {
		block: {
			index: 0,
			stack: []
		}
	};
	for (let i = 0; i < lines.length; i++) {
		const line = lines[i];
		const ctx: CmdContext = {
			lines,
			defined,
			addToOutput(s: string) { output += s },
			setState(st: string) { state = st },
			getState() { return state },
			infoStack,
			lineIndex: i,
			line,
			filename: fname,
			data
		}
		if (line.startsWith('--!')) {
			const macroText: string = line.slice(3);
			const [cmd, ...args] = macroText.split(' ');
			
			for (const cmdk in macroCmds) { // why tf did i do this instead of macroCmds[cmd]()
				const cmdv = macroCmds[cmdk];
				if (cmdk === cmd) {
					cmdv(args, ctx);
				}
			}
			if (!macroCmds.hasOwnProperty(cmd)) errorMsg(ctx, 'Unknown command: ' + cmd);
		} else {
			switch (state) {
				case "normal": {
					output += line + "\n";
					break;
				}
				case "blockRead": {
					let buf = infoStack.pop();
					buf += line + "\n";
					infoStack.push(buf);
					break;
				}
				default: {
					errorMsg(ctx, 'Unknown state: ' + state);
					break;
				}
			}
		}
	}
	return { final: performMacroReplacements(output, defined), processed: output, vars: defined };
}

const argv = process.argv.slice(2);

const [file, output, ...opt] = argv;
const predef: { [key: string]: string } = {};

for (const option of opt) {
	if (option.startsWith('-D')) {
		let oname = option.slice(2);
		let oval = "";
		if (option.includes('=')) {
			oname = option.slice(2).split('=')[0];
			oval = option.split('=')[1];
		}
		predef[oname] = oval;
	}
}

//console.log(predef);

const fileData = await fs.readFile(file, "utf-8");
const outputData = processMacros(file, fileData, predef);
if (output === "-") {
	process.stdout.write(outputData.final);
} else {
	await fs.writeFile(output, outputData, "utf-8");
}

